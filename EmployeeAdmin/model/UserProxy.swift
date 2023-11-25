//
//  UserProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation
import CoreData

class UserProxy: Proxy {
       
    override class var NAME: String { "UserProxy" }
    
    private var context: NSManagedObjectContext
        
    init(_ context: NSManagedObjectContext) {
        self.context = context
        super.init(name: UserProxy.NAME, data: [User]())
    }
    
    func findAll() throws -> [User] {
        let request = User.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
        return try context.fetch(request)
    }

    func save(_ user: User) throws {
        try context.save()
    }

    func update(_ user: User) throws {
        try context.save()
    }

    func delete(_ user: User) throws {
        context.delete(user)
        try context.save()
    }

    func findAllDepartments() throws -> [Department] {
        let request = Department.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
        return try context.fetch(request)
    }

}
