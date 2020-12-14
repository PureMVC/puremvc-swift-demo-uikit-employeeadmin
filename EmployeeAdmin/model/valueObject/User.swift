//
//  User.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SQLite3

struct User {
    
    var id: Int64?
    var username: String?
    var first: String?
    var last: String?
    var email: String?
    var password: String?
    var department: Department?
    
    init(id: Int64? = nil, username: String?, first:String?, last:String?, email:String?, password:String?, department:Department?) {
        self.id = id
        self.username = username ?? ""
        self.first = first ?? ""
        self.last = last ?? ""
        self.email = email ?? ""
        self.password = password ?? ""
        self.department = department ?? nil
    }
    
    init(_ statement: OpaquePointer?) {
        if sqlite3_column_int64(statement, 0) != 0 { id = sqlite3_column_int64(statement, 0) }
        if sqlite3_column_text(statement, 1) != nil { username = String(cString: sqlite3_column_text(statement, 1)) }
        if sqlite3_column_text(statement, 1) != nil { first = String(cString: sqlite3_column_text(statement, 2)) }
        if sqlite3_column_text(statement, 3) != nil { last = String(cString: sqlite3_column_text(statement, 3)) }
        if sqlite3_column_text(statement, 4) != nil { email = String(cString: sqlite3_column_text(statement, 4)) }
        if sqlite3_column_text(statement, 5) != nil { password = String(cString: sqlite3_column_text(statement, 5)) }
        if sqlite3_column_int64(statement, 6) != 0 && sqlite3_column_text(statement, 7) != nil {
            department = Department(id: sqlite3_column_int64(statement, 6), name: String(cString: sqlite3_column_text(statement, 7)))
        }
    }
    
    var isValid:Bool {
        username != "" && first != "" && last != "" && email != "" && password != "" && department != nil && department!.id != 0
    }
    
    var givenName: String? {
        [last, first].compactMap { $0 }.joined(separator: ", ")
    }
    
}
