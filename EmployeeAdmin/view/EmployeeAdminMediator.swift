//
//  EmployeeAdminMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import Combine
import PureMVC

class EmployeeAdminMediator: Mediator {
    
    private var userProxy: UserProxy!
    
    private var roleProxy: RoleProxy!
    
    init(name: String, viewComponent: any ObservableObject) {
        super.init(name: name, viewComponent: viewComponent)
    }
    
    override func onRegister() {
        userProxy = (facade.retrieveProxy(UserProxy.NAME) as! UserProxy)
        roleProxy = (facade.retrieveProxy(RoleProxy.NAME) as! RoleProxy)
        
        switch viewComponent {
        case let observable as UserListViewModel:
            observable.delegate = self
        case let observable as UserFormViewModel:
            observable.delegate = self
        case let observable as UserRoleViewModel:
            observable.delegate = self
        default:
            print("default viewComponent")
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
        return userProxy.findAllDepartments()
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
