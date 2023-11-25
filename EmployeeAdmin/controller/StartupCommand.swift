//
//  StartupCommand.swift
//  PureMVC SWIFT Demo - userAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation
import CoreData
import UIKit

class StartupCommand: SimpleCommand {
    
    override func execute(_ notification: INotification) {

        guard let appDelegate = notification.body as? AppDelegate else { return }

        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let existingUsers = try context.fetch(User.fetchRequest())
            if (existingUsers.isEmpty) {
                let accounting = Department(context: context, name: "Accounting")
                let sales = Department(context: context, name: "Sales")
                let plant = Department(context: context, name: "Plant")
                _ = Department(context: context, name: "Shipping")
                _ = Department(context: context, name: "Quality Control")
                
                _ = Role(context: context, name: "Administrator")
                _ = Role(context: context, name: "Accounts Payable")
                let accountsReceivable = Role(context: context, name: "Accounts Receivable")
                let employeeBenefits = Role(context: context, name: "Employee Benefits")
                let generalLedger = Role(context: context, name: "General Ledger")
                _ = Role(context: context, name: "Payroll")
                _ = Role(context: context, name: "Inventory")
                let production = Role(context: context, name: "Production")
                _ = Role(context: context, name: "Quality Control")
                let sales2 = Role(context: context, name: "Sales")
                _ = Role(context: context, name: "Orders")
                _ = Role(context: context, name: "Customers")
                let shipping2 = Role(context: context, name: "Shipping")
                _ = Role(context: context, name: "Returns")
                
                _ = User(context: context, username: "lstooge", first: "Larry", last: "Stooge", email: "lary@stooges.com", password: "ijk456",
                        department: accounting, roles: NSSet(array: [employeeBenefits]))
                _ = User(context: context, username: "cstooge", first: "Curly", last: "Stooge", email: "curly@stooges.com", password: "xyz987",
                        department: sales, roles: NSSet(array: [accountsReceivable, generalLedger]))
                _ = User(context: context, username: "mstooge", first: "Moe", last: "Stooge", email: "moe@stooges.com", password: "abc123",
                        department: plant, roles: NSSet(array: [production, sales2, shipping2]))
            }
            
            facade.registerProxy(UserProxy(context))
            facade.registerProxy(RoleProxy(context))
            facade.registerMediator(ApplicationMediator(appDelegate))
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
