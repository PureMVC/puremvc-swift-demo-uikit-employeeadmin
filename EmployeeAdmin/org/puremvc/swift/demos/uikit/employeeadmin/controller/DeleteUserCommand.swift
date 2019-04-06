//
//  DeleteUserCommand.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class DeleteUserCommand: SimpleCommand {
    
    // retrieve the user and role proxies and delete the user
    // and his roles. then send the USER_DELETED notification
    override func execute(_ notification: INotification) {
        let userVO = notification.body as! UserVO
        if let userProxy = facade.retrieveProxy(UserProxy.NAME) as? UserProxy {
            userProxy.deleteItem(userVO)
        }
        if let roleProxy = facade.retrieveProxy(RoleProxy.NAME) as? RoleProxy {
            roleProxy.deleteItem(userVO)
        }
    }
    
}
