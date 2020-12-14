//
//  Department.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import SQLite3

struct Department {
    
    var id: Int64?
    var name: String?
    
    init(id: Int64? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }
    
    init(_ statement: OpaquePointer? = nil) {
        if sqlite3_column_int64(statement, 0) != 0 { id = sqlite3_column_int64(statement, 0) }
        if sqlite3_column_text(statement, 1) != nil { name = String(cString: sqlite3_column_text(statement, 1)) }
    }
    
}
