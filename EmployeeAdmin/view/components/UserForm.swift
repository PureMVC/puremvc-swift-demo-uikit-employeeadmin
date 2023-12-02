//
//  UserForm.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit
import Combine

protocol UserFormDelegate : AnyObject {
    func findById(_ id: Int) -> AnyPublisher<User, Error>
    func save(_ user: User, roles: [Role]?) -> AnyPublisher<User, Error>
    func update(_ user: User, roles: [Role]?) -> AnyPublisher<User, Error>
    func findAllDepartments() -> AnyPublisher<[Department], Error>
}

class UserForm: UIViewController {
        
    public var user: User?
    
    private var departments: [Department]? = [Department(id: 0, name: "--None Selected--")]
        
    private var cancellable = Set<AnyCancellable>()
    
    var responder: ((User?) -> Void)?
    
    weak var delegate: UserFormDelegate?

    open class var NAME: String { "UserForm" }

    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var department: UIPickerView!
    @IBOutlet weak var userRoles: UITableView!
    
    override func viewDidLoad() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(name: UserForm.NAME, viewComponent: self)
        
        guard let delegate else { return }
                
        var publishers = Publishers.Zip(delegate.findAllDepartments(),
                                        Just(User(id: 0)).setFailureType(to: Error.self).eraseToAnyPublisher())
        
        if let user, user.id != 0 { // existing user
            publishers = Publishers.Zip(delegate.findAllDepartments(), delegate.findById(user.id)) // User Data (conditional)
        }
        
        publishers // Parallelize UI and User Data requests
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] departments, user in // Bind UI and User Data
                self?.departments?.append(contentsOf: departments)
                self?.department.reloadComponent(0)
                self?.bind(user: user)
            })
            .store(in: &cancellable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userRoles.tableFooterView = UIView()
    }

    func bind(user: User) {
        self.user = user
        username.isEnabled = user.id == 0
        first.text = user.first
        last.text = user.last
        email.text = user.email
        username.text = user.username
        password.text = user.password
        confirmPassword.text = user.password
        department.selectRow(Int(user.department?.id ?? 0), inComponent: 0, animated: true)
    }
    
    @IBAction func save(_ sender: Any) { // save or update
        guard var user, let delegate else { return }
        
        user.username = username.text
        user.first = first.text ?? ""
        user.last = last.text ?? ""
        user.email = email.text ?? ""
        user.password = password.text ?? ""
        user.department = Department(id: department.selectedRow(inComponent: 0), name: departments?[department.selectedRow(inComponent: 0)].name ?? "")
        
        guard user.password == confirmPassword.text && user.isValid else {
            return fault(nil, message: "Invalid Form Data.")
        }
        
        let publisher = (user.id == 0) ? delegate.save(user, roles: user.roles) : delegate.update(user, roles: user.roles)
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error)}
            }, receiveValue: { [weak self] user in
                self?.user?.id = user.id
                self?.responder?(user)
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .store(in: &cancellable)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToUserRoles",
            let userRole = segue.destination as? UserRole {
            
            user?.first = first.text ?? "" // Retain any form changes before the segue
            user?.last = last.text ?? ""
            user?.email = email.text ?? ""
            user?.password = password.text ?? ""
            user?.department?.id = department.selectedRow(inComponent: 0)
            
            userRole.user = user
            userRole.responder = { [weak self] user in
                self?.user = user
            }
        }
    }

    func fault(_ error: Error?, message: String? = nil) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        if let error = error {
            alert.title = "\(type(of: error))"
            alert.message = error.localizedDescription
        }
        if let message = message { alert.message = message }
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    deinit {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).removeView(name: UserForm.NAME)
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
