//
//  UserListMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import UIKit

class EmployeeAdminMediator: Mediator { 
    
    override class var NAME: String { "EmployeeAdminMediator" }

    var userProxy: UserProxy?
    
    var roleProxy: RoleProxy?
    
    init(viewComponent: UIViewController) {
        super.init(name: EmployeeAdminMediator.NAME + viewComponent.title!, viewComponent: viewComponent)
    }
    
    override func onRegister() {
        userProxy = facade.retrieveProxy(UserProxy.NAME) as? UserProxy
        roleProxy = facade.retrieveProxy(RoleProxy.NAME) as? RoleProxy
        
        switch viewComponent {
        case let userList as UserList:
            userList.delegate = self
        case let userForm as UserForm:
            userForm.delegate = self
        case let userRole as UserRole:
            userRole.delegate = self
        default:
            print("default")
        }
    }
}

extension EmployeeAdminMediator: UserListDelegate {

    func findAll() throws -> [User]? {
        try userProxy?.findAll()
    }

    func delete(_ user: User?) throws {
        guard let user = user else { return }
        try userProxy?.delete(user)
    }

}

extension EmployeeAdminMediator: UserFormDelegate {

    func save(_ user: User?) throws {
        guard let user else { return }
        try userProxy?.save(user)
    }
    
    func update(_ user: User?) throws {
        guard let user else { return }
        try userProxy?.update(user)
    }
    
    func findAllDepartments() throws -> [Department]? {
        try userProxy?.findAllDepartments()
    }
    
}

extension EmployeeAdminMediator: UserRoleDelegate {
    
    func findAllRoles() throws -> [Role]? {
        try roleProxy?.findAll()
    }
    
}
