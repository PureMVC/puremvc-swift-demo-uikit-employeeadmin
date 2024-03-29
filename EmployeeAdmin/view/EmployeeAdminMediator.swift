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

    private var userProxy: UserProxy?
    
    private var roleProxy: RoleProxy?
    
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
    
    func findAll(_ completion: @escaping ([User]?, NSException?) -> Void) {
        userProxy?.findAll(completion)
    }
    
    func deleteById(_ id: Int?, _ completion: @escaping (Int?, NSException?) -> Void) {
        if let id = id {
            userProxy?.deleteById(id, completion)
        } else {
            completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "Id can't be nil.", userInfo: nil))
        }
    }
    
}

extension EmployeeAdminMediator: UserFormDelegate {
 
    func findById(_ id: Int?, _ completion: @escaping (User?, NSException?) -> Void) {
        if let id = id {
            userProxy?.findById(id, completion)
        }
    }
    
    func save(_ user: User?, roles: [Role]?, completion: @escaping (Int?, NSException?) -> Void) {
        if let user = user {
            userProxy?.save(user) { [weak self] (id, exception) in

                guard exception == nil else {
                    completion(nil, exception)
                    return
                }

                if let id = id, let roles = roles {
                    self?.roleProxy?.updateByUserId(id, roles: roles, { (ids, exception) in
                        guard exception == nil else {
                            completion(nil, exception)
                            return
                        }
                        completion(id, nil)
                    })
                } else {
                    completion(id, nil)
                }
            }
        } else {
            completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "User can't be nil.", userInfo: nil))
        }
    }
    
    func update(_ user: User?, roles: [Role]?, completion: @escaping (Int?, NSException?) -> Void) {
        if let user = user {
            userProxy?.update(user) { [weak self] (modified, exception) in
                
                guard exception == nil else {
                    completion(nil, exception)
                    return
                }
                
                if let roles = roles, let id = user.id {
                    self?.roleProxy?.updateByUserId(id, roles: roles) { _, exception in
                        
                        guard exception == nil else {
                            completion(nil, exception)
                            return
                        }
                        completion(modified, nil)
                    }
                } else {
                    completion(modified, nil)
                }
            }
        } else {
            completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "User can't be nil.", userInfo: nil))
        }
    }
    
    func findAllDepartments(_ completion: @escaping ([Department]?, NSException?) -> Void) {
        userProxy?.findAllDepartments(completion)
    }
    
}

extension EmployeeAdminMediator: UserRoleDelegate {

    func findAllRoles(_ completion: @escaping ([Role]?, NSException?) -> Void){
        roleProxy?.findAll(completion)
    }
    
    func findRolesById(_ id: Int?, _ completion: @escaping ([Role]?, NSException?) -> Void) {
        if let id = id {
            roleProxy?.findByUserId(id, completion)
        } else {
            completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "Id can't be nil.", userInfo: nil))
        }
    }
    
}
