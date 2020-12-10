//
//  StartupCommand.swift
//  PureMVC SWIFT Demo - userAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation
import UIKit

class StartupCommand: SimpleCommand {
    
    override func execute(_ notification: INotification) {
        facade.registerProxy(UserProxy())
        facade.registerProxy(RoleProxy())
    }
    
}
