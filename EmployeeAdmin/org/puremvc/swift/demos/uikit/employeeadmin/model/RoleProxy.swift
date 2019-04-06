//
//  RoleProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class RoleProxy: Proxy {
    
    override class var NAME: String { return "RoleProxy" }
    
    init() {
        super.init(proxyName: RoleProxy.NAME, data: [RoleVO]())
    }
    
    // add an item to the data
    func addItem(_ item: Any) {
        var roles = data as! [RoleVO]
        roles.append(item as! RoleVO)
        data = roles;
    }
    
    func addRoleVO(_ roleVO: RoleVO) {
        var roles = data as! [RoleVO]
        var found = false;
        for (_, element) in roles.enumerated() {
            if(roleVO.username == element.username) {
                element.roles = roleVO.roles
                found = true
                break
            }
        }
        if(!found) {
            roles.append(roleVO)
            data = roles
        }
    }
    
    // delete an item from the data
    func deleteItem(_ item: Any) {
        var roles = data as! [RoleVO]
        for (index, element) in roles.enumerated() {
            if(element.username == (item as! UserVO).username) {
                roles.remove(at: index)
                data = roles
                break
            }
        }
    }
    
    // get a users roles
    func getUserRoles(_ username: String) -> [RoleEnum] {
        var userRoles = [RoleEnum]()
        var roles = data as! [RoleVO]
        for (index, element) in roles.enumerated() {
            if (element.username == username) {
                userRoles = roles[index].roles
            }
        }
        return userRoles
    }
    
}
