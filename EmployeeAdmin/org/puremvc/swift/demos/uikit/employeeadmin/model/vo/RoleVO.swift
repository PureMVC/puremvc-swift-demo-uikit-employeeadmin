//
//  RoleVO.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

class RoleVO {
    
    var username: String
    var roles: [RoleEnum]
    
    init(username: String, roles: [RoleEnum]) {
        self.username = username
        self.roles = roles
    }

}
