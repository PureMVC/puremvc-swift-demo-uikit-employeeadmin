//
//  UserListMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import UIKit
import Combine

class EmployeeAdminMediator: Mediator { 

    private var userProxy: UserProxy!
    
    private var roleProxy: RoleProxy!
    
    init(name: String, viewComponent: UIResponder) {
        super.init(name: name, viewComponent: viewComponent)
    }
    
    override func onRegister() { // Forced unwrapping and casting streamlined delegate methods
        //  but the app is susceptible to ceasing to work if these core dependencies are not available.
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
    
    func findAll() -> AnyPublisher<[User], Error> {
        userProxy.findAll()
    }

    func deleteById(_ id: Int) -> AnyPublisher<Never, Error> {
        userProxy.deleteById(id)
    }
    
}

extension EmployeeAdminMediator: UserFormDelegate {

    func findById(_ id: Int) -> AnyPublisher<User, Error> {
        userProxy.findById(id)
    }
    
    func save(_ user: User, roles: [Role]?) -> AnyPublisher<User, Error> {
        userProxy.save(user)
                .flatMap { [weak self] user in
                    guard let roles, let roleProxy = self?.roleProxy else {
                        return Just(user).setFailureType(to: Error.self).eraseToAnyPublisher()
                    }
                    return roleProxy.updateByUserId(user.id, roles: roles)
                            .map { _ in user }
                            .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
    }

    func update(_ user: User, roles: [Role]?) -> AnyPublisher<User, Error> {
        userProxy.update(user)
                .flatMap { [weak self] user in
                    guard let roles, let roleProxy = self?.roleProxy else {
                        return Just(user).setFailureType(to: Error.self).eraseToAnyPublisher()
                    }
                    return roleProxy.updateByUserId(user.id, roles: roles)
                            .map { _ in user }
                            .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
    }
    
    func findAllDepartments() -> AnyPublisher<[Department], Error> {
        userProxy.findAllDepartments()
    }
    
}

extension EmployeeAdminMediator: UserRoleDelegate {

    func findAllRoles() -> AnyPublisher<[Role], Error> {
        roleProxy.findAll()
    }
    
    func findRolesById(_ id: Int) -> AnyPublisher<[Role], Error> {
        roleProxy.findByUserId(id)
    }
    
}
