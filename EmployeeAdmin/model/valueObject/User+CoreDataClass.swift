//
//  User+CoreDataClass.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext, username: String?, first: String?, last: String?, email: String?, password: String?, department: Department?, roles: NSSet?) {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.email = email
        self.first = first
        self.last = last
        self.password = password
        self.username = username
        self.department = department
        self.roles = roles
        created = Date()
    }

    var isValid:Bool {
        username != "" && first != "" && last != "" && email != "" && password != "" && department != nil
    }
    
    var givenName: String? {
        [last, first].compactMap { $0 }.joined(separator: ", ")
    }
    
}
