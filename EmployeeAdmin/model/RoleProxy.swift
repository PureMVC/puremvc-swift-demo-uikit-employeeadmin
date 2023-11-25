//
//  RoleProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation
import CoreData

class RoleProxy: Proxy {
    
    override class var NAME: String { "RoleProxy" }
    
    private var context: NSManagedObjectContext
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
        super.init(name: RoleProxy.NAME, data: [Role]())
    }
    
    func findAll() throws -> [Role] {
        let request = Role.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
        return try context.fetch(request)
    }
    
}
