//
//  UserVO.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class UserVO {
    
    var username: String
    var fname: String
    var lname: String
    var email: String
    var password: String
    var department: DeptEnum
    
    init(username: String?=nil, fname:String?=nil, lname:String?=nil, email:String?=nil, password:String?=nil, department:DeptEnum?=nil) {
        self.username = username ?? ""
        self.fname = fname ?? ""
        self.lname = lname ?? ""
        self.email = email ?? ""
        self.password = password ?? ""
        self.department = department ?? DeptEnum.NONE_SELECTED
    }
    
    var isValid:Bool {
        return username != "" && password != "" && !department.equals(DeptEnum.NONE_SELECTED)
    }
    
    var givenName: String {
        return lname + ", " + fname
    }
    
}
