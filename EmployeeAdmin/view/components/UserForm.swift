//
//  UserForm.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserFormDelegate : AnyObject {
    func findById(_ id: Int) async throws -> User
    func save(_ user: User, _ roles: [Role]?) async throws -> User
    func update(_ user: User, _ roles: [Role]?) async throws -> User
    func findAllDepartments() async throws -> [Department]
}

class UserForm: UIViewController {
        
    var user: User?
        
    private var departments: [Department]? = [Department(id: 0, name: "--None Selected--")]
        
    var responder: ((User?) -> Void)?
    
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
        
        guard let user, let delegate else { return }
        
        Task {
            do {
                let (departments, user) = try await(delegate.findAllDepartments(),
                                                    user.id != 0 ? delegate.findById(user.id) : user)
                self.departments?.append(contentsOf: departments)
                self.department.reloadComponent(0)
                self.bind(user: user)
            } catch (let error as Exception) {
                fault(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userRoles.tableFooterView = UIView()
    }
    
    @IBAction func save(_ sender: Any) { // save or update
        guard var user, let delegate else { return }
        
        user.username = username.text ?? ""
        user.first = first.text ?? ""
        user.last = last.text ?? ""
        user.email = email.text ?? ""
        user.password = password.text ?? ""
        user.department = Department(id: department.selectedRow(inComponent: 0), name: departments?[department.selectedRow(inComponent: 0)].name)
        
        guard user.password == confirmPassword.text && user.isValid else {
            return fault(Exception(message: "Invalid Form Data."))
        }
        
        Task {
            do {
                let action = (user.id == 0) ? delegate.save : delegate.update
                user = try await action(user, user.roles)
                responder?(user)
                navigationController?.popToRootViewController(animated: true)
            } catch(let error as Exception) {
                fault(error)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // segue to User Roles
        if let identifier = segue.identifier, identifier == "segueToUserRoles" {
            if let destination = segue.destination as? UserRole {
                user?.first = first.text // retain any form changes before the segue
                user?.last = last.text
                user?.email = email.text
                user?.password = password.text
                user?.department?.id = department.selectedRow(inComponent: 0)
                
                destination.user = user
                destination.responder = { [weak self] user in
                    self?.user = user
                }
            }
        }
    }
    
    func bind(user: User) {
        self.user = user
        first.text = user.first
        last.text = user.last
        email.text = user.email
        username.isEnabled = user.id == 0
        username.text = user.username
        password.text = user.password
        confirmPassword.text = user.password
        department.selectRow(Int(user.department?.id ?? 0), inComponent: 0, animated: true)
    }
    
    func fault(_ exception: Exception) {
        let alertController = UIAlertController(title: "Error", message: exception.message, preferredStyle: UIAlertController.Style.alert)
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
