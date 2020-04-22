//
//  ApplicationFacade.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import UIKit

class ApplicationFacade: Facade {
    
    // Notification name constants
    static var STARTUP = "startup"
        
    static var REGISTER = "register"
    
    /**
    Register Commands with the Controller
    */
    override func initializeController() {
        super.initializeController()
        registerCommand(ApplicationFacade.STARTUP) { StartupCommand() }
        registerCommand(ApplicationFacade.REGISTER) { RegisterComand() }
    }
    
    /**
    Singleton Factory Method
    */
    class func getInstance(key: String) -> ApplicationFacade {
        return Facade.getInstance(key) { k in ApplicationFacade(key: k) } as! ApplicationFacade
    }
    
    func registerView(view: UIResponder) {
        sendNotification(ApplicationFacade.REGISTER, body: view)
    }
    
    /**
    Start the application
    */
    func startup(_ appDelegate: AppDelegate) {
        sendNotification(ApplicationFacade.STARTUP, body: appDelegate)
    }
    
}
