//
//  Role+CoreDataProperties.swift
//  EmployeeAdmin
//
//  Created by Saad Shams on 11/24/23.
//
//

import Foundation
import CoreData


extension Role {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Role> {
        NSFetchRequest<Role>(entityName: "Role")
    }

    @NSManaged public var name: String?
    @NSManaged public var created: Date?
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for users
extension Role {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: User)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: User)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}

extension Role : Identifiable {

}
