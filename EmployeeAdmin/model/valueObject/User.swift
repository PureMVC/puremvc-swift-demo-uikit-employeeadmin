//
//  User.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

struct User: Decodable, Encodable {
    
    var id: Int
    var username: String?
    var first: String?
    var last: String?
    var email: String?
    var password: String?
    var department: Department?
    
    init(id: Int, username: String? = nil, first:String? = nil, last:String? = nil, email:String? = nil, password:String? = nil, department:Department? = nil) {
        self.id = id
        self.username = username
        self.first = first
        self.last = last
        self.email = email
        self.password = password
        self.department = department
    }
    
    var isValid:Bool {
        username != "" && first != "" && last != "" && email != "" && password != "" && department != nil &&
                department!.id != 0 && department!.name != ""
    }
    
    var givenName: String? {
        [last ?? "", first ?? ""].joined(separator: ", ")
    }
    
}
