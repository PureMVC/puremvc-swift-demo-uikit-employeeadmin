//
//  RegisterCommand.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import UIKit

class RegisterCommand: SimpleCommand {
    
    override func execute(_ notification: INotification) {

        switch notification.body {
            
            case let viewComponent as UIViewController:
                if(facade.hasMediator(EmployeeAdminMediator.NAME + viewComponent.title!)) {
                    facade.removeMediator(EmployeeAdminMediator.NAME + viewComponent.title!)
                }
                facade.registerMediator(EmployeeAdminMediator(viewComponent: viewComponent))
            
            default:
                break
        }
    }
}
