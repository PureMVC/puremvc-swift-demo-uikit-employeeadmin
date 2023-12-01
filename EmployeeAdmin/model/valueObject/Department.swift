//
//  Department.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation

struct Department: Identifiable, Hashable, Codable {
    
    var id: Int
    var name: String?
    
    init(id: Int, name: String? = nil) {
        self.id = id
        self.name = name
    }
    
}
