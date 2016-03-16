//
//  UserForm.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit
import PureMVC

protocol UserFormDelegate: class {
    func onAdd(userVO: UserVO)
    func onUpdate(userVO: UserVO)
    func onUserRolesSelected(userVO: UserVO)
}

class UserForm: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    weak var _delegate: UserFormDelegate?
    
    enum Mode {
        case MODE_ADD
        case MODE_EDIT
    }
    
    var _mode: Mode?
    
    var _userVO: UserVO?

    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var department: UIPickerView!
    
    @IBOutlet weak var userRoleCell: UITableViewCell!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")
    }
    
    // populate user details
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userVO = userVO {
            fname.text = userVO.fname
            lname.text = userVO.lname
            email.text = userVO.email
            username.text = userVO.username
            password.text = userVO.password
            confirmPassword.text = userVO.password
            department.selectRow(userVO.department.hashValue, inComponent: 0, animated: false)
        }
        
        username.enabled = (mode == .MODE_ADD)
        userRoleCell.userInteractionEnabled = (mode == .MODE_EDIT)
        userRoleCell.textLabel?.enabled = (mode == .MODE_EDIT)

        navigationItem.title = (mode == .MODE_ADD) ? "Add User" : "User Profile"
        tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false) //reset scroll
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    // save or update
    func save() {
        let userVO = UserVO(username: username.text, fname: fname.text, lname: lname.text, email: email.text, password: password.text, department: DeptEnum.comboList[department.selectedRowInComponent(0)])
            
        if (userVO.password == confirmPassword.text && userVO.isValid == true) {
            mode == .MODE_ADD ? delegate?.onAdd(userVO) : delegate?.onUpdate(userVO)
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            let alertController = UIAlertController(title: "Error", message:"Invalid Form Data.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // select user roles
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let userVO = userVO where indexPath.section == 1 && indexPath.row == 0 {
            delegate?.onUserRolesSelected(userVO)
        }
    }
    
    // UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DeptEnum.comboList[row].rawValue
    }
    
    // UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewDataSource
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DeptEnum.comboList.count
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    var userVO: UserVO? {
        get { return _userVO }
        set { _userVO = newValue }
    }
    
    var mode: Mode? {
        get { return _mode }
        set { _mode = newValue }
    }
    
    var delegate: UserFormDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
}