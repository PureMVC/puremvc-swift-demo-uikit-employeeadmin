//
//  UserForm.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserFormDelegate : class {
    func findById(_ id: Int64?) throws -> User?
    func save(_ user: User?, roles: [Role]?) throws
    func update(_ user: User?, roles: [Role]?) throws
    func findAllDepartments() throws -> [Department]?
}

class UserForm: UIViewController {
    
    var id: Int64?
    
    var user: User?
    
    var departments: [Department]? = [Department(id: 0, name: "--None Selected--")]
        
    var roles: [Role]?
    
    weak var delegate: UserFormDelegate?

    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var department: UIPickerView!
    @IBOutlet weak var userRoles: UITableView!
    
    override func viewDidLoad() {
        (UIApplication.shared.delegate as! AppDelegate).registerView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userRoles.tableFooterView = UIView()
        
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async { [weak self] in // UI data
            do {
                if let departments = try self?.delegate?.findAllDepartments() {
                    self?.departments?.append(contentsOf: departments)
                }
                group.leave()
            } catch let error as NSError {
                DispatchQueue.main.async { self?.fault("\(error.localizedDescription), \(error.domain), \(error.code)") }
            }
        }
        
        if self.user == nil { // User data
            group.enter()
            DispatchQueue.global().async { [weak self] in
                do {
                    if let user = try self?.delegate?.findById(self?.id) {
                        self?.user = user
                    }
                    group.leave()
                } catch let error as NSError {
                    DispatchQueue.main.async { self?.fault("\(error.localizedDescription), \(error.domain), \(error.code)") }
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in // Stitch UI and User Data
            self?.department.reloadComponent(0)
            
            if let user = self?.user {
                self?.first.text = user.first
                self?.last.text = user.last
                self?.email.text = user.email
                self?.username.text = user.username
                self?.username.isEnabled = false
                self?.password.text = user.password
                self?.confirmPassword.text = user.password
                self?.department.selectRow(Int(user.department?.id ?? 0), inComponent: 0, animated: true)
            }
        }
        
    }
    
    @IBAction func save(_ sender: Any) { // save or update
        if user == nil { // new user
            user = User(id: nil, username: username.text, first: first?.text,
                        last: last.text, email: email.text, password: password.text,
                        department: Department(id: Int64(department.selectedRow(inComponent: 0)), name: nil))
        } else { // existing user
            user?.first = first.text ?? ""
            user?.last = last.text ?? ""
            user?.email = email.text ?? ""
            user?.password = password.text ?? ""
            user?.department?.id = Int64(department.selectedRow(inComponent: 0))
            user?.department?.name = departments?[department.selectedRow(inComponent: 0)].name
        }
        
        if user!.password == confirmPassword.text && user!.isValid == true { // validation
            if user?.id == nil {
                DispatchQueue.global().async { [weak self] in
                    do {
                        try self?.delegate?.save(self?.user, roles: self?.roles)
                        DispatchQueue.main.async { [weak self] in
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                    } catch let error as NSError {
                        DispatchQueue.main.async { self?.fault("\(error.localizedDescription), \(error.domain), \(error.code)") }
                    }
                }
            } else {
                DispatchQueue.global().async { [weak self] in
                    do {
                        try self?.delegate?.update(self?.user, roles: self?.roles)
                        DispatchQueue.main.async { [weak self] in
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                    } catch let error as NSError {
                        DispatchQueue.main.async { self?.fault("\(error.localizedDescription), \(error.domain), \(error.code)") }
                    }
                }
            }
        } else {
            fault("Invalid Form Data.")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // segue to User Roles
        if let identifier = segue.identifier, identifier == "segueToUserRoles" {
            if let userRole = segue.destination as? UserRole {
                user?.first = first.text ?? "" // retain any form changes before the segue
                user?.last = last.text ?? ""
                user?.email = email.text ?? ""
                user?.password = password.text ?? ""
                user?.department?.id = Int64(department.selectedRow(inComponent: 0))
                
                userRole.id = user?.id
                userRole.roles = roles // previous selection if any
                userRole.responder = self
            }
        }
    }
    
    func fault(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}

extension UserForm: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 } // number of rows
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "userRolesCell", for: indexPath as IndexPath)
        cell.textLabel?.text = "User Roles"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Seque to UserRoles
        performSegue(withIdentifier: "segueToUserRoles", sender: user)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserForm: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { // title
        departments?[row].name
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 } // number of components
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { // number of rows
        departments?.count ?? 0
    }
}

extension UserForm: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // resign keyboard
        textField.resignFirstResponder()
        return true
    }
}

extension UserForm: UserRoleResponder {
    func result(_ roles: [Role]?) { // add role to the user
        self.roles = roles
    }
}
