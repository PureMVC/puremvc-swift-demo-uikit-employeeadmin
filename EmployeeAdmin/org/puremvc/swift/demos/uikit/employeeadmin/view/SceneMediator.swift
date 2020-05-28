//
//  SceneMediator.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class SceneMediator: Mediator {
    
    override class var NAME: String { "SceneMediator" }
    
    init(viewComponent: SceneDelegate) {
        super.init(name: SceneMediator.NAME, viewComponent: viewComponent)
    }
    
}
