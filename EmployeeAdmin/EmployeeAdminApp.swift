//
//  EmployeeAdminApp.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SwiftUI
import PureMVC

@main
struct EmployeeAdminApp: App {
    
    var body: some Scene {
        WindowGroup {
            UserList()
        }
    }
    
    init() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).startup(self)
    }

}
