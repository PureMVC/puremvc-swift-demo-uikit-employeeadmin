//
//  EmployeeAdmin.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol EmployeeAdminDelegate: class {
    func viewDidLoad()
}

class EmployeeAdmin: UINavigationController {
    
    weak var _delegate: EmployeeAdminDelegate?
    
    var userList: UserList!
    var userForm: UserForm!
    var userRole: UserRole!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userList = viewControllers[0] as! UserList
        userForm = storyboard!.instantiateViewControllerWithIdentifier("UserForm") as! UserForm
        userRole = storyboard!.instantiateViewControllerWithIdentifier("UserRole") as! UserRole
        _delegate?.viewDidLoad()
    }
    
    func showUserForm() {
        self.pushViewController(userForm, animated: true)
    }
    
    func showUserRoles() {
        self.pushViewController(userRole, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
