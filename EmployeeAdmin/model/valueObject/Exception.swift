//
//  Exception.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

struct Exception: Decodable, Encodable {
    
    var code: String?
    var message: String?
    
    init(code: String? = nil, message: String? = nil) {
        self.code = code
        self.message = message
    }
    
}
