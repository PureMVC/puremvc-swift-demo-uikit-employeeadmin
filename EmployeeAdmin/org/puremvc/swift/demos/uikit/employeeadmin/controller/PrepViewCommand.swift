//
//  PrepViewCommand.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
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
    override func execute(_ notification: INotification) {
        if let appDelegate = notification.body as? AppDelegate {
            facade.registerMediator(ApplicationMediator(viewComponent: appDelegate))
        }
    }
    
}
