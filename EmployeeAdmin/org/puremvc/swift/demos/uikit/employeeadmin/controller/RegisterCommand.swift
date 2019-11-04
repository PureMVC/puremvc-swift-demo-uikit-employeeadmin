//
//  RegisterCommand.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class RegisterComand: SimpleCommand {
    
    override func execute(_ notification: INotification) {
        
        if let userList = notification.body as? UserList {
            facade.registerMediator(UserListMediator(viewComponent: userList))
        }
        
    }
    
}
