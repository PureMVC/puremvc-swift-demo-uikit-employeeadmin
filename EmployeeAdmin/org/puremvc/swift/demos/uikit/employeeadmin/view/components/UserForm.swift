//
//  UserForm.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserFormDelegate : class {
    func add(_ userVO: UserVO, roleVO: RoleVO)
    func update(_ userVO: UserVO, roleVO: RoleVO)
}

class UserForm: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UserRoleDelegate {
    
    weak var delegate: UserFormDelegate?
    
    var userVO: UserVO?
    
    var roleVO: RoleVO? = RoleVO()

    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var department: UIPickerView!
    @IBOutlet weak var userRoles: UITableView!
    
    // populate user details
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userRoles.isScrollEnabled = false
        
        if let userVO = userVO {
            fname.text = userVO.fname
            lname.text = userVO.lname
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
    
    // segue to User Roles
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "segueToUserRoles" {
            if let userRole = segue.destination as? UserRole { // save temporary if user changed any values
                userVO?.fname = fname.text ?? ""
                userVO?.lname = lname.text ?? ""
                userVO?.email = email.text ?? ""
                userVO?.username = username.text ?? ""
                userVO?.password = password.text ?? ""
                userVO?.department = DeptEnum.comboList[department.selectedRow(inComponent: 0)]
                userRole.roles = roleVO?.roles
                userRole.delegate = self
            }
        }
    }
    
    // UserRoleDelegate - add role to the user
    func addRole(_ role: RoleEnum) {
        roleVO?.roles.append(role)
    }
    
    // UserRoleDelegate - remove role from the user
    func removeRole(_ role: RoleEnum) {
        if let index = roleVO?.roles.firstIndex(of: role) {
            roleVO?.roles.remove(at: index)
        }
    }
    
    // save or update
    @IBAction func save(_ sender: Any) { // save rules
        if userVO == nil {
            userVO = UserVO()
            userVO?.username = username.text!
            roleVO?.username = username.text!
        }
        
        if let userVO = userVO {
            userVO.fname = fname.text ?? ""
            userVO.lname = lname.text ?? ""
            userVO.email = email.text ?? ""
            userVO.password = password.text ?? ""
            userVO.department = DeptEnum.comboList[department.selectedRow(inComponent: 0)]
            
            if userVO.password == confirmPassword.text && userVO.isValid == true {
                username.isEnabled ? delegate?.add(userVO, roleVO: roleVO!) : delegate?.update(userVO, roleVO: roleVO!)
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                let alertController = UIAlertController(title: "Error", message:"Invalid Form Data.", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    // Seque to UserRoles
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToUserRoles", sender: userVO)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // UserRoles number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // UserRoles cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userRolesCell", for: indexPath as IndexPath)
        cell.textLabel?.text = "User Roles"
        return cell
    }
    
    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DeptEnum.comboList[row].rawValue
    }
    
    // UIPickerViewDataSource number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewDataSource number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DeptEnum.comboList.count
    }
    
    // resign keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
