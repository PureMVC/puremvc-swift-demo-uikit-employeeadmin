//
//  ApplicationFacade.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class ApplicationFacade: Facade {
    
    // Notification name constants
    static var STARTUP = "startup"
    
    static var NEW_USER = "newUser"
    static var DELETE_USER = "deleteUser"
    
    static var USER_SELECTED = "userSelected"
    static var USER_ADDED = "userAdded"
    static var USER_UPDATED = "userUpdated"
    
    static var ADD_ROLE_RESULT = "addRoleResult"
        
    static var SHOW_USER_ROLES = "showUserRoles"
    
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
    class func getInstance() -> ApplicationFacade {
        return super.getInstance { ApplicationFacade() } as! ApplicationFacade
    }
    
    /**
    Start the application
    */
    func startup(app: EmployeeAdmin) {
        sendNotification(ApplicationFacade.STARTUP, body: app)
    }
    
}