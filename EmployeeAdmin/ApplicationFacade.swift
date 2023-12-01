//
//  ApplicationFacade.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import SwiftUI
import PureMVC

class ApplicationFacade: Facade {
    
    // Notification name constants
    static var KEY = "EmployeeAdmin"
    
    static var STARTUP = "startup"
            
    /** Register Commands with the Controller */
    override func initializeController() {
        super.initializeController()
        registerCommand(ApplicationFacade.STARTUP) { StartupCommand() }
    }
    
    /** Singleton Factory Method */
    class func getInstance(key: String) -> ApplicationFacade {
        Facade.getInstance(key) { k in ApplicationFacade(key: k) } as! ApplicationFacade
    }
    
    /** register mediator for the view */
    func registerView(name: String, viewComponent: any ObservableObject) {
        removeView(name: name)
        switch viewComponent {
        case let observable as UserListViewModel:
            registerMediator(EmployeeAdminMediator(name: name + "Mediator", viewComponent: observable))
        case let observable as UserFormViewModel:
            registerMediator(EmployeeAdminMediator(name: name + "Mediator", viewComponent: observable))
        case let observable as UserRoleViewModel:
            registerMediator(EmployeeAdminMediator(name: name + "Mediator", viewComponent: observable))
        default:
            break
        }
    }

    /** remove mediator for the view */
    func removeView(name: String) {
        if(hasMediator(name + "Mediator")) { removeMediator(name + "Mediator") }
    }
    
    /** Start the application */
    func startup(_ app: any App) {
        sendNotification(ApplicationFacade.STARTUP, body: app as Any)
    }
    
}
