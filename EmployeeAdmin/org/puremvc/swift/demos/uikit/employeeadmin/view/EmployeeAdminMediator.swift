//
//  EmployeeAdminMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class EmployeeAdminMediator: Mediator, EmployeeAdminDelegate {
    
    override class var NAME: String { return "EmployeeAdminMediator" }
    
    init(viewComponent: EmployeeAdmin) {
        super.init(mediatorName: EmployeeAdminMediator.NAME, viewComponent: viewComponent)
    }
    
    override func onRegister() {
        employeeAdmin._delegate = self
    }
    
    func viewDidLoad() {
        facade.registerMediator(UserListMediator(viewComponent: employeeAdmin.userList))
        facade.registerMediator(UserFormMediator(viewComponent: employeeAdmin.userForm))
        facade.registerMediator(UserRoleMediator(viewComponent: employeeAdmin.userRole))
    }
    
    override func listNotificationInterests() -> [String] {
        return [
            ApplicationFacade.NEW_USER,
            ApplicationFacade.USER_SELECTED,
            ApplicationFacade.SHOW_USER_ROLES
        ]
    }
    
    override func handleNotification(notification: INotification) {
        switch notification.name {
        case ApplicationFacade.NEW_USER:
            employeeAdmin.showUserForm()
        case ApplicationFacade.USER_SELECTED:
            employeeAdmin.showUserForm()
        case ApplicationFacade.SHOW_USER_ROLES:
            employeeAdmin.showUserRoles()
        default:
            break
        }
    }
    
    var employeeAdmin: EmployeeAdmin {
        return viewComponent as! EmployeeAdmin
    }
    
}