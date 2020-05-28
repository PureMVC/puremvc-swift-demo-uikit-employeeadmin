//
//  UserForm.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserFormDelegate : class {
    func save(_ userVO: UserVO, roleVO: RoleVO)
    func update(_ userVO: UserVO, roleVO: RoleVO?)
}

class UserForm: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UserRoleResponder {
    
    var userVO: UserVO?
    
    var roles: [RoleEnum]?
    
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
    
    // populate user details
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userRoles.isScrollEnabled = false
        
        if let userVO = userVO {
            first.text = userVO.first
            last.text = userVO.last
            email.text = userVO.email
            username.text = userVO.username
            username.isEnabled = false
            password.text = userVO.password
            confirmPassword.text = userVO.password
            for (index, element) in DeptEnum.comboList.enumerated() {
                if(userVO.department.equals(element)) {
                    department.selectRow(index, inComponent: 0, animated: false)
                    break;
                }
            }
        }
    }
    
    // save or update
    @IBAction func save(_ sender: Any) {
        if userVO == nil { // new user
            userVO = UserVO(username: username.text, first: first?.text, last: last.text, email: email.text, password: password.text, department: DeptEnum.comboList[department.selectedRow(inComponent: 0)])
        } else if let userVO = userVO { // existing user
            userVO.first = first.text ?? ""
            userVO.last = last.text ?? ""
            userVO.email = email.text ?? ""
            userVO.password = password.text ?? ""
            userVO.department = DeptEnum.comboList[department.selectedRow(inComponent: 0)]
        }
        
        if userVO!.password == confirmPassword.text && userVO!.isValid == true { // validation
            if username.isEnabled {
                let roleVO: RoleVO = roles != nil ? RoleVO(username: userVO!.username, roles: roles!) : RoleVO(username: userVO!.username, roles: [RoleEnum]())
                delegate?.save(userVO!, roleVO: roleVO)
            } else {
                let roleVO: RoleVO? = roles != nil ? RoleVO(username: userVO!.username, roles: roles!) : nil // user roles may not be updated
                delegate?.update(userVO!, roleVO: roleVO)
            }
            
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "Error", message:"Invalid Form Data.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // Seque to UserRoles
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToUserRoles", sender: userVO)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // segue to User Roles
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "segueToUserRoles" {
            if let userRole = segue.destination as? UserRole {
                userRole.username = userVO?.username
                userRole.roles = roles
                userRole.responder = self
            }
        }
    }
    
    // MARK: - UserRoleResponder
    
    // add role to the user
    func result(_ roles: [RoleEnum]) {
        self.roles = roles
    }
    
    // MARK: - UITableViewDelegate
    
    // UserRoles number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    // UserRoles cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userRolesCell", for: indexPath as IndexPath)
        cell.textLabel?.text = "User Roles"
        return cell
    }
    
    // MARK: - UIPickerViewDelegate
    
    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        DeptEnum.comboList[row].rawValue
    }
    
    // UIPickerViewDataSource number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    // UIPickerViewDataSource number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        DeptEnum.comboList.count
    }
    
    // resign keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
