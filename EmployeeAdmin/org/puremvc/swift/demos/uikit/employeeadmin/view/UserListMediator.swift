//
//  UserListMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class UserListMediator: Mediator, UserListDelegate {

    var userProxy: UserProxy?
    var roleProxy: RoleProxy?
    
    override class var NAME: String { return "UserListMediator" }
    
    init(viewComponent: UserList) {
        super.init(mediatorName: UserListMediator.NAME, viewComponent: viewComponent)
    }
    
    override func onRegister() {
        userProxy = facade.retrieveProxy(UserProxy.NAME) as? UserProxy
        roleProxy = facade.retrieveProxy(RoleProxy.NAME) as? RoleProxy
        userList.delegate = self
        userList.userVOs = userProxy?.users;
    }
    
    func add(_ userVO: UserVO, roleVO: RoleVO) {
        userProxy?.addItem(userVO)
        roleProxy?.addRoleVO(roleVO)
    }
    
    func update(_ userVO: UserVO, roleVO: RoleVO) {
        userProxy?.updateItem(userVO)
        roleProxy?.addRoleVO(roleVO)
    }
    
    func delete(_ userVO: UserVO) {
        sendNotification(ApplicationFacade.DELETE_USER, body: userVO)
    }
    
    func getUserRoles(_ username: String) -> [RoleEnum] {
        return roleProxy?.getUserRoles(username) ?? [RoleEnum]()
    }
    
    var userList: UserList {
        return viewComponent as! UserList
    }
    
}
