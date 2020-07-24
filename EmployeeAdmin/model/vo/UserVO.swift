//
//  UserVO.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

struct UserVO {
    
    var username: String
    var first: String
    var last: String
    var email: String
    var password: String
    var department: DeptEnum
    
    init(username: String?, first:String?, last:String?, email:String?, password:String?, department:DeptEnum?) {
        self.username = username ?? ""
        self.first = first ?? ""
        self.last = last ?? ""
        self.email = email ?? ""
        self.password = password ?? ""
        self.department = department ?? .NONE_SELECTED
    }
    
    var isValid:Bool {
        username != "" && first != "" && last != "" && email != "" && password != "" && !department.equals(.NONE_SELECTED)
    }
    
    var givenName: String {
        last + ", " + first
    }
    
}
