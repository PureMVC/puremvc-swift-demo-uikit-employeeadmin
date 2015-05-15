//
//  PrepViewCommand.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class PrepViewCommand: SimpleCommand {
    
    /**
    Prepare the View.
    
    Get the View Components for the Mediators from the app,
    a reference to which was passed on the original startup
    notification.
    */
    override func execute(notification: INotification) {
        var app = notification.body as! EmployeeAdmin

        facade.registerMediator(EmployeeAdminMediator(viewComponent: app))
    }
    
}