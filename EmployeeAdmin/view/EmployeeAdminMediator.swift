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
    
    func findAll(_ completion: @escaping (Result<[User], Exception>) -> Void) {
        userProxy?.findAll(completion)
    }
    
    func deleteById(_ id: Int, _ completion: @escaping (Result<Void, Exception>) -> Void) {
        userProxy?.deleteById(id, completion)
    }
    
}

extension EmployeeAdminMediator: UserFormDelegate {

    func findById(_ id: Int, _ completion: @escaping (Result<User, Exception>) -> Void) {
        userProxy?.findById(id, completion)
    }
    
    func save(_ user: User, _ roles: [Role]?, _ completion: @escaping (Result<User, Exception>) -> Void) {

        userProxy?.save(user) { [weak self] result in
            switch result {
            case .success(let user):
                guard let roles else { return completion(.success(user)) }
                self?.roleProxy?.updateByUser(user, roles: roles) { result in
                    switch result {
                    case .success(_): completion(.success(user))
                    case .failure(let exception): completion(.failure(exception))
                    }
                }
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }
    
    func update(_ user: User, _ roles: [Role]?, _ completion: @escaping (Result<User, Exception>) -> Void) {
        userProxy?.update(user) { [weak self] result in
            switch result {
            case .success(let user):
                guard let roles else { return completion(.success(user)) }
                self?.roleProxy?.updateByUser(user, roles: roles) { result in
                    switch result {
                    case .success(_): completion(.success(user))
                    case .failure(let exception): completion(.failure(exception))
                    }
                }
            case .failure(let exception):
                completion(.failure(exception))
            }
        }
    }
    
    func findAllDepartments(_ completion: @escaping (Result<[Department], Exception>) -> Void) {
        userProxy?.findAllDepartments(completion)
    }
    
}

extension EmployeeAdminMediator: UserRoleDelegate {

    func findAllRoles(_ completion: @escaping (Result<[Role], Exception>) -> Void) {
        roleProxy?.findAll(completion)
    }
    
    func findRolesByUser(_ user: User, _ completion: @escaping (Result<[Role], Exception>) -> Void) {
        roleProxy?.findByUser(user, completion)
    }
    
}
