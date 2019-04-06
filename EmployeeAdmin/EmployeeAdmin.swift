//
//  EmployeeAdmin.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol EmployeeAdminDelegate: class {
    func viewDidLoad()
}

class EmployeeAdmin: UINavigationController {
    
    weak var _delegate: EmployeeAdminDelegate?
    
    var userList: UserList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if viewControllers.count != 0, let userList = viewControllers[0] as? UserList {
            self.userList = userList
            _delegate?.viewDidLoad() // register mediator for userList
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
