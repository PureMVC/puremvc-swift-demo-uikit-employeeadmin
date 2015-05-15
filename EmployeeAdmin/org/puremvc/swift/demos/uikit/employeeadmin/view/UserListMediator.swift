//
//  UserListMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class UserListMediator: Mediator, UserListDelegate {
    
    var userProxy: UserProxy!
    
    override class var NAME: String { return "UserListMediator" }
    
    init(viewComponent: UserList) {
        super.init(mediatorName: UserListMediator.NAME, viewComponent: viewComponent)
    }
    
    override func onRegister() {
        userList.delegate = self
        userProxy = (facade.retrieveProxy(UserProxy.NAME) as! UserProxy)
        userList.users = userProxy.users
    }
    
    func onNew() {
        sendNotification(ApplicationFacade.NEW_USER, body: UserVO())
    }
    
    func onDelete(userVO: UserVO) {
        sendNotification(ApplicationFacade.DELETE_USER, body: userVO)
    }
    
    func onSelect(userVO: UserVO) {
        sendNotification(ApplicationFacade.USER_SELECTED, body: userVO)
    }
    
    override func listNotificationInterests() -> [String] {
        return [
            ApplicationFacade.USER_ADDED,
            ApplicationFacade.USER_UPDATED
        ]
    }
    
    override func handleNotification(notification: INotification) {
        switch notification.name {
        case ApplicationFacade.USER_ADDED:
            userList.add(notification.body as! UserVO)
        case ApplicationFacade.USER_UPDATED:
            userList.update(notification.body as! UserVO)
        default:
            break
        }
    }
    
    var userList: UserList {
        return viewComponent as! UserList
    }
    
}
