//
//  EmployeeAdminMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class EmployeeAdminMediator: Mediator, EmployeeAdminDelegate {
    
    override class var NAME: String { return "EmployeeAdminMediator" }
    
    init(viewComponent: EmployeeAdmin) {
        super.init(mediatorName: EmployeeAdminMediator.NAME, viewComponent: viewComponent)
    }
    
    override func onRegister() {
        employeeAdmin._delegate = self
    }
    
    func viewDidLoad() {
        facade.registerMediator(UserListMediator(viewComponent: employeeAdmin.userList))
    }
    
    var employeeAdmin: EmployeeAdmin {
        return viewComponent as! EmployeeAdmin
    }
    
}
