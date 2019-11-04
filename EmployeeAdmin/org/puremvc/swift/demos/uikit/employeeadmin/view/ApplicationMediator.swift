//
//  ApplicationMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class ApplicationMediator: Mediator {
    
    override class var NAME: String { return "ApplicationMediator" }
    
    init(viewComponent: AppDelegate) {
        super.init(mediatorName: ApplicationMediator.NAME, viewComponent: viewComponent)
    }
    
}
