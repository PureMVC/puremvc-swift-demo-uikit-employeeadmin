//
//  ApplicationFacade.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class ApplicationFacade: Facade {
    
    // Notification name constants
    static var STARTUP = "startup"
    
    static var DELETE_USER = "deleteUser"
    
    /**
    Register Commands with the Controller
    */
    override func initializeController() {
        super.initializeController()
        registerCommand(ApplicationFacade.STARTUP) { StartupCommand() }
        registerCommand(ApplicationFacade.DELETE_USER) { DeleteUserCommand() }
    }
    
    /**
    Singleton Factory Method
    */
    class func getInstance(key: String) -> ApplicationFacade {
        return super.getInstance(key) { ApplicationFacade(key: key) } as! ApplicationFacade
    }
    
    /**
    Start the application
    */
    func startup(_ appDelegate: AppDelegate) {
        sendNotification(ApplicationFacade.STARTUP, body: appDelegate)
    }
    
}
