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
        return try userProxy?.findAll()
    }
    
    func deleteById(_ id: Int64?) throws -> Int32? {
        if let id = id {
            return try userProxy?.deleteById(id)
        } else {
            return nil
        }
    }
    
}

extension EmployeeAdminMediator: UserFormDelegate {
    
    func findById(_ id: Int64?) throws -> User? {
        if let id = id {
            return try userProxy?.findById(id)
        } else {
            return nil
        }
    }
    
    func save(_ user: User?, roles: [Role]?) throws {
        if let user = user {
            let id = try userProxy?.save(user)
            
            if let id = id, let roles = roles {
                _ = try roleProxy?.updateByUserId(id, roles: roles.compactMap { $0.id })
            }
        }
    }
    
    func update(_ user: User?, roles: [Role]?) throws {
        if let user = user {
            _ = try userProxy?.update(user)
            
            if let id = user.id, let roles = roles {
                _ = try roleProxy?.updateByUserId(id, roles: roles.compactMap { $0.id })
            }
        }
    }
    
    func findAllDepartments() throws -> [Department]? {
        return try userProxy?.findAllDepartments()
    }
    
}

extension EmployeeAdminMediator: UserRoleDelegate {
    
    func findAllRoles() throws -> [Role]? {
        try roleProxy?.findAll()
    }
    
    func findRolesById(id: Int64?) throws -> [Role]? {
        if let id = id {
            return try roleProxy?.findByUserId(id)
        } else {
            return nil
        }
    }
    
}
