//
//  RoleVO.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation

class RoleVO {
    
    var username: String
    var roles: [RoleEnum]
    
    init(username: String?=nil, roles: [RoleEnum]?=nil) {
        self.username = username ?? ""
        self.roles = roles ?? [RoleEnum]()
    }

}