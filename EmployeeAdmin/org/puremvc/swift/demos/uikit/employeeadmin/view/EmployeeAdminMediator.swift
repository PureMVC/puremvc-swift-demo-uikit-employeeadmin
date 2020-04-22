//
//  UserListMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import UIKit

class EmployeeAdminMediator: Mediator, UserListDelegate, UserFormDelegate, UserRoleDelegate {

    var userProxy: UserProxy?
    var roleProxy: RoleProxy?
    
    override class var NAME: String { return "EmployeeAdminMediator" }
    
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
    
    func users() -> [UserVO] {
        return userProxy!.users
    }
    
    func save(_ userVO: UserVO, roleVO: RoleVO) {
        userProxy!.addItem(userVO)
        roleProxy!.addItem(roleVO)
    }
    
    func update(_ userVO: UserVO, roleVO: RoleVO?) {
        userProxy!.updateItem(userVO)
        if let roleVO = roleVO {
            roleProxy!.updateUserRoles(username: userVO.username, role: roleVO.roles)
        }
    }
    
    func delete(_ userVO: UserVO) {
        userProxy!.deleteItem(userVO.username)
        roleProxy!.deleteItem(userVO.username)
    }
    
    func getUserRoles(username: String) -> [RoleEnum]? {
        return roleProxy!.getUserRoles(username)
    }
    
}
