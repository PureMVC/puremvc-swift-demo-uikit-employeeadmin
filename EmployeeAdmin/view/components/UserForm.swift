//
//  UserForm.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserFormDelegate : AnyObject {
    func save(_ user: User?) throws
    func update(_ user: User?) throws
    func findAllDepartments() throws -> [Department]?
}

class UserForm: UIViewController {

    var user: User?

    private var roles: NSSet?
    
    private var departments: [Department] = []
    
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
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(view: self)
        
        DispatchQueue.global().async { [weak self] in // UI data
            do {
                if let departments = try self?.delegate?.findAllDepartments() {
                    self?.departments.append(contentsOf: departments)
                    DispatchQueue.main.async {
                        self?.department.reloadComponent(0) // Stitch UI Data
                    }
                }
            } catch let error as NSError {
                DispatchQueue.main.async { self?.fault("\(error.localizedDescription), \(error.domain), \(error.code)") }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userRoles.tableFooterView = UIView()

        if let user = user { // Stitch User Data
            first.text = user.first
            last.text = user.last
            email.text = user.email
            username.text = user.username
            username.isEnabled = false
            password.text = user.password
            confirmPassword.text = user.password
            if let index = departments.firstIndex(where: { $0 == user.department } ) {
                department.selectRow(index + 1, inComponent: 0, animated: true)
            }
        }
    }

    @IBAction func save(_ sender: Any) { // save or update
        if user == nil { // new user
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                return
            }
            user = User(context: context, username: username?.text, first: first?.text,
                    last: last.text, email: email.text, password: password.text,
                    department: departments[department.selectedRow(inComponent: 0) - 1], roles: roles)
        } else { // existing user
            user?.first = first.text ?? ""
            user?.last = last.text ?? ""
            user?.email = email.text ?? ""
            user?.password = password.text ?? ""
            user?.department = departments[department.selectedRow(inComponent: 0) - 1]
            user?.roles = roles
        }

        guard let user = user, user.password == confirmPassword.text, user.isValid == true else {
            return fault("Invalid Form Data.")
        }

        DispatchQueue.global().async { [weak self] in // update
            do {
                try user.objectID.isTemporaryID ? self?.delegate?.save(user) : self?.delegate?.update(user)
                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            } catch let error as NSError {
                DispatchQueue.main.async { self?.fault("\(error.localizedDescription), \(error.domain), \(error.code)") }
            }
        }
    }

    // segue to User Roles
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "segueToUserRoles" {
            if let userRole = segue.destination as? UserRole {
                user?.first = first.text ?? "" // retain any form changes before the segue
                user?.last = last.text ?? ""
                user?.email = email.text ?? ""
                user?.password = password.text ?? ""
                user?.department = departments[department.selectedRow(inComponent: 0) - 1]

                userRole.roles = roles != nil ? roles : user?.roles // previous selection if any
                userRole.responder = self
            }
        }
    }

    func fault(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}

extension UserForm: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 } // number of rows

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "userRolesCell", for: indexPath as IndexPath)
        cell.textLabel?.text = "User Roles"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Segue to UserRoles
        performSegue(withIdentifier: "segueToUserRoles", sender: user)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserForm: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { // title
        (row == 0) ? "--None Selected--" : departments[row - 1].name
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 } // number of components
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { // number of rows
        departments.count + 1
    }
}

extension UserForm: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // resign keyboard
        textField.resignFirstResponder()
        return true
    }
}

extension UserForm: UserRoleResponder {
    func result(_ roles: NSSet?) { // add role to the user
        self.roles = roles
    }
}
