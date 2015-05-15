//
//  UserRoleMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class UserRoleMediator: Mediator, UserRoleDelegate {
    
    override class var NAME: String { return "UserRoleMediator" }
    
    var roleProxy: RoleProxy!
    
    init(viewComponent: UserRole) {
        super.init(mediatorName: UserRoleMediator.NAME, viewComponent: viewComponent)
    }
    
    override func onRegister() {
        userRole.delegate = self
        roleProxy = (facade.retrieveProxy(RoleProxy.NAME) as! RoleProxy)
    }
    
    func onAdd(userVO: UserVO, role: RoleEnum) {
        roleProxy.addRoleToUser(userVO, role: role)
    }
    
    func onDelete(userVO: UserVO, role: RoleEnum) {
        roleProxy.removeRoleFromUser(userVO, role: role)
    }
    
    func doesUserHaveRole(userVO: UserVO, role: RoleEnum) -> Bool {
        return roleProxy!.doesUserHaveRole(userVO, role: role)
    }
    
    override func listNotificationInterests() -> [String] {
        return [
            ApplicationFacade.NEW_USER,
            ApplicationFacade.USER_ADDED,
            ApplicationFacade.USER_SELECTED,
            ApplicationFacade.SHOW_USER_ROLES,
            ApplicationFacade.ADD_ROLE_RESULT
        ]
    }
    
    override func handleNotification(notification: INotification) {
        switch notification.name {
        case ApplicationFacade.NEW_USER:
            userRole.userVO = (notification.body as! UserVO)
        case ApplicationFacade.USER_ADDED:
            var userVO = notification.body as! UserVO
            roleProxy.addItem(RoleVO(username: userVO.username))
        case ApplicationFacade.USER_SELECTED:
            userRole.userVO = (notification.body as! UserVO)
        case ApplicationFacade.SHOW_USER_ROLES:
            userRole.userRoles = roleProxy.getUserRoles(userRole.userVO!.username)
        case ApplicationFacade.ADD_ROLE_RESULT:
            userRole.userRoles = roleProxy.getUserRoles(userRole.userVO!.username)
        default:
            break
        }
    }
    
    var userRole: UserRole {
        return viewComponent as! UserRole
    }
    
}