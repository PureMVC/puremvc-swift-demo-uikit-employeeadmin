//
//  RoleProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class RoleProxy: Proxy {
    
    override class var NAME: String { "RoleProxy" }
    
    init() {
        super.init(name: RoleProxy.NAME, data: [RoleVO]())
    }
    
    // add an item to the data
    func addItem(_ item: RoleVO) {
        roles.append(item)
    }
    
    // update user roles
    func updateUserRoles(username: String, role: [RoleEnum]) {
        for (index, element) in roles.enumerated() {
            if (element.username == username) {
                roles[index].roles = role
                break
            }
        }
    }
    
    // get a users roles
    func getUserRoles(_ username: String) -> [RoleEnum]? {
        var roleEnums: [RoleEnum]?
        for (index, element) in roles.enumerated() {
            if (element.username == username) {
                roleEnums = roles[index].roles
            }
        }
        return roleEnums
    }
    
    // delete an item from the data
    func deleteItem(_ username: String) {
        for (index, element) in roles.enumerated() {
            if(element.username == username) {
                roles.remove(at: index)
                break
            }
        }
    }
    
    var roles: [RoleVO] {
        get { data as! [RoleVO] }
        set { data = newValue }
    }
    
}
