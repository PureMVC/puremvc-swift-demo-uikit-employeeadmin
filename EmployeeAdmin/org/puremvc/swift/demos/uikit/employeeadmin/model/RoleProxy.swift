//
//  RoleProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class RoleProxy: Proxy {
    
    override class var NAME: String { return "RoleProxy" }
    
    init() {
        super.init(name: RoleProxy.NAME, data: [RoleVO]())
    }
    
    // add an item to the data
    func addItem(_ item: RoleVO) {
        var roles = data as! [RoleVO]
        roles.append(item)
        data = roles;
    }
    
    // update user roles
    func updateUserRoles(username: String, role: [RoleEnum]) {
        for (_, element) in roles.enumerated() {
            if (element.username == username) {
                element.roles = role
                break
            }
        }
    }
    
    // get a users roles
    func getUserRoles(_ username: String) -> [RoleEnum]? {
        var userRoles: [RoleEnum]?
        let roles = data as! [RoleVO]
        for (index, element) in roles.enumerated() {
            if (element.username == username) {
                userRoles = roles[index].roles
            }
        }
        return userRoles
    }
    
    // delete an item from the data
    func deleteItem(_ username: String) {
        var roles = data as! [RoleVO]
        for (index, element) in roles.enumerated() {
            if(element.username == username) {
                roles.remove(at: index)
                data = roles
                break
            }
        }
    }
    
    var roles: [RoleVO] {
        return data as! [RoleVO]
    }
    
}
