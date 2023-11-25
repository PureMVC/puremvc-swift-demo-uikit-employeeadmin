//
//  Role+CoreDataClass.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import CoreData

@objc(Role)
public class Role: NSManagedObject {

    convenience init(context: NSManagedObjectContext, name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Role", in: context)!
        self.init(entity: entity, insertInto: context)
        self.name = name
        created = Date()
    }
    
}
