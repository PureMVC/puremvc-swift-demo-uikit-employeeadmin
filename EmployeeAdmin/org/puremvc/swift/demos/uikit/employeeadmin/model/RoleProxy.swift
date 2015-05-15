//
//  RoleProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class RoleProxy: Proxy {
    
    override class var NAME: String { return "RoleProxy" }
    
    init() {
        super.init(proxyName: RoleProxy.NAME, data: [RoleVO]())
    }
    
    // add an item to the data
    func addItem(item: Any) {
        var roles = data as! [RoleVO]
        roles.append(item as! RoleVO)
        data = roles;
    }
    
    // delete an item from the data
    func deleteItem(item: Any) {
        var roles = data as! [RoleVO]
        for (index, element) in enumerate(roles) {
            if(element.username == (item as! UserVO).username) {
                roles.removeAtIndex(index)
                data = roles
                break
            }
        }
    }
    
    // determine if the user has a given role
    func doesUserHaveRole(user: UserVO, role: RoleEnum) -> Bool {
        var hasRole = false
        var roles = data as! [RoleVO]
        for (i, element) in enumerate(roles) {
            if(element.username == user.username) {
                var userRoles = roles[i].roles
                for(j, element) in enumerate(userRoles) {
                    if (element.equals(role)) {
                        hasRole = true
                        break
                    }
                }
                
            }
        }
        return hasRole
    }
    
    // add a role to this user
    func addRoleToUser(user: UserVO, role: RoleEnum) {
        var result = false
        if(!doesUserHaveRole(user, role: role)) {
            var roles = data as! [RoleVO]
            for (i, element) in enumerate(roles) {
                if (element.username == user.username) {
                    var userRoles = roles[i].roles
                    userRoles.append(role)
                    roles[i].roles = userRoles
                    result = true
                    break
                }
            }
        }
        sendNotification(ApplicationFacade.ADD_ROLE_RESULT, body: result)
    }
    
    // remove a role from the user
    func removeRoleFromUser(user: UserVO, role: RoleEnum) {
        if(doesUserHaveRole(user, role: role)) {
            var roles = data as! [RoleVO]
            for (i, element) in enumerate(roles) {
                if (element.username == user.username) {
                    var userRoles = roles[i].roles
                    for (j, element) in enumerate(userRoles) {
                        if (element.equals(role)) {
                            userRoles.removeAtIndex(j)
                            roles[i].roles = userRoles
                            break
                        }
                    }
                    break
                }
            }
        }
    }
    
    // get a users roles
    func getUserRoles(username: String) -> [RoleEnum] {
        var userRoles = [RoleEnum]()
        var roles = data as! [RoleVO]
        for (index, element) in enumerate(roles) {
            if (element.username == username) {
                userRoles = roles[index].roles
            }
        }
        return userRoles
    }
    
}