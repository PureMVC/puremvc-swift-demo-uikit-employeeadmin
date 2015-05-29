//
//  UserFormMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class UserFormMediator: Mediator, UserFormDelegate {
    
    override class var NAME: String { return "UserFormMediator" }
    
    var userProxy: UserProxy?
    
    init(viewComponent: UserForm) {
        super.init(mediatorName: UserFormMediator.NAME, viewComponent: viewComponent)
    }
    
    override func onRegister() {
        userForm.delegate = self
        userProxy = facade.retrieveProxy(UserProxy.NAME) as? UserProxy
    }
    
    func onAdd(userVO: UserVO) {
        userProxy?.addItem(userVO)
        sendNotification(ApplicationFacade.USER_ADDED, body: userVO)
    }
    
    func onUpdate(userVO: UserVO) {
        userProxy?.updateItem(userVO)
        sendNotification(ApplicationFacade.USER_UPDATED, body: userVO)
    }
    
    func onUserRolesSelected(userVO: UserVO) {
        sendNotification(ApplicationFacade.SHOW_USER_ROLES, body: userVO.username)
    }
    
    override func listNotificationInterests() -> [String] {
        return [
            ApplicationFacade.NEW_USER,
            ApplicationFacade.USER_SELECTED
        ]
    }
    
    override func handleNotification(notification: INotification) {
        switch notification.name {
        case ApplicationFacade.NEW_USER:
            userForm.userVO = (notification.body as! UserVO)
            userForm.mode = .MODE_ADD
        case ApplicationFacade.USER_SELECTED:
            userForm.userVO = (notification.body as! UserVO)
            userForm.mode = .MODE_EDIT
        default:
            break
        }
    }
    
    var userForm: UserForm {
        return viewComponent as! UserForm
    }
    
}