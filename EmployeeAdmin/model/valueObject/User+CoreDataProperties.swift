//
//  User+CoreDataProperties.swift
//  EmployeeAdmin
//
//  Created by Saad Shams on 11/24/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var first: String?
    @NSManaged public var last: String?
    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var created: Date?
    @NSManaged public var department: Department?
    @NSManaged public var roles: NSSet?

}

// MARK: Generated accessors for roles
extension User {

    @objc(addRolesObject:)
    @NSManaged public func addToRoles(_ value: Role)

    @objc(removeRolesObject:)
    @NSManaged public func removeFromRoles(_ value: Role)

    @objc(addRoles:)
    @NSManaged public func addToRoles(_ values: NSSet)

    @objc(removeRoles:)
    @NSManaged public func removeFromRoles(_ values: NSSet)

}

extension User : Identifiable {

}
