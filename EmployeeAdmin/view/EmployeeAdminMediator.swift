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

    private var userProxy: UserProxy!
    
    private var roleProxy: RoleProxy!
    
    init(viewComponent: UIViewController) {
        super.init(name: EmployeeAdminMediator.NAME + viewComponent.title!, viewComponent: viewComponent)
    }
    
    override func onRegister() {
        userProxy = (facade.retrieveProxy(UserProxy.NAME) as! UserProxy)
        roleProxy = (facade.retrieveProxy(RoleProxy.NAME) as! RoleProxy)
        
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
    
    func findAll() async throws -> [User] {
        try await userProxy.findAll()
    }
    
    func deleteById(_ id: Int) async throws {
        try await userProxy.deleteById(id)
    }
    
}

extension EmployeeAdminMediator: UserFormDelegate {

    func findById(_ id: Int) async throws -> User {
        try await userProxy.findById(id)
    }
    
    func save(_ user: User, _ roles: [Role]?) async throws -> User {
        let user = try await userProxy.save(user)
        
        if let roles = roles {
            _ = try await roleProxy.updateByUser(user, roles: roles)
        }

        return user
    }
    
    func update(_ user: User, _ roles: [Role]?) async throws -> User {
        let user = try await userProxy.update(user)
        
        if let roles = roles {
            _ = try await roleProxy.updateByUser(user, roles: roles)
        }

        return user
    }
    
    func findAllDepartments() async throws -> [Department] {
        try await userProxy.findAllDepartments()
    }
    
}

extension EmployeeAdminMediator: UserRoleDelegate {

    func findAllRoles() async throws -> [Role] {
        try await roleProxy.findAll()
    }
    
    func findRolesByUser(_ user: User) async throws -> [Role] {
        try await roleProxy.findByUser(user)
    }
    
}
