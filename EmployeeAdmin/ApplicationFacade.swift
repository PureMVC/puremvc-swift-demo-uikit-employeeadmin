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
    static var KEY = "EmployeeAdmin"
    
    static var STARTUP = "startup"
            
    /**
    Register Commands with the Controller
    */
    override func initializeController() {
        super.initializeController()
        registerCommand(ApplicationFacade.STARTUP) { StartupCommand() }
    }
    
    /**
    Singleton Factory Method
    */
    class func getInstance(key: String) -> ApplicationFacade {
        Facade.getInstance(key) { k in ApplicationFacade(key: k) } as! ApplicationFacade
    }
    
    /**
    register mediator for the view
     */
    func registerView(name: String, viewComponent: UIResponder) {
        removeView(name: name)
        switch viewComponent {
        case let viewComponent as SceneDelegate:
            registerMediator(SceneMediator(name: name + "Mediator", viewComponent: viewComponent))
        case let viewComponent as AppDelegate:
            registerMediator(AppDelegateMediator(name: name + "Mediator", viewComponent: viewComponent))
        case let viewComponent as UIViewController:
            registerMediator(EmployeeAdminMediator(name: name + "Mediator", viewComponent: viewComponent))
        default:
            break
        }
    }

    /**
    remove mediator for the view
     */
    func removeView(name: String) {
        if(hasMediator(name + "Mediator")) { removeMediator(name + "Mediator") }
    }
    
    /**
    Start the application
    */
    func startup(_ delegate: AppDelegate) {
        sendNotification(ApplicationFacade.STARTUP, body: delegate)
    }
    
}
