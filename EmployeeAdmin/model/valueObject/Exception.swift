//
//  Exception.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

struct Exception: Error, Codable {
    
    let code: Int?
    let message: String
    
    init(_ code: Int = 0, message: String) {
        self.code = code
        self.message = message
    }

}
