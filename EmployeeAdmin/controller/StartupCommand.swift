//
//  StartupCommand.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import PureMVC

class StartupCommand: SimpleCommand {
    
    override func execute(_ notification: INotification) {
        let configuration = URLSessionConfiguration.default
        configuration.allowsConstrainedNetworkAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        let session = URLSession(configuration: configuration)

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        facade.registerProxy(UserProxy(session: session, encoder: encoder, decoder: decoder))
        facade.registerProxy(RoleProxy(session: session, encoder: encoder, decoder: decoder))
    }
    
}
