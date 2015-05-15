//
//  DeleteUserCommand.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class DeleteUserCommand: SimpleCommand {
    
    // retrieve the user and role proxies and delete the user
    // and his roles. then send the USER_DELETED notification
    override func execute(notification: INotification) {
        var userVO = notification.body as! UserVO
        var userProxy = facade.retrieveProxy(UserProxy.NAME) as! UserProxy
        var roleProxy = facade.retrieveProxy(RoleProxy.NAME) as! RoleProxy
        userProxy.deleteItem(userVO)
        roleProxy.deleteItem(userVO)
        sendNotification(ApplicationFacade.USER_DELETED)
    }
    
}
