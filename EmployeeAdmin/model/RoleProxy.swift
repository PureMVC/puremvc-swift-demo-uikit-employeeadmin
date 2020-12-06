//
//  RoleProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation
import SQLite3

class RoleProxy: Proxy {
    
    override class var NAME: String { "RoleProxy" }
    
    internal var database: OpaquePointer!
    
    init(_ database: OpaquePointer) {
        super.init(name: RoleProxy.NAME, data: [Role]())
        self.database = database
    }
    
    func findAll() throws -> [Role]? {
        var statement: OpaquePointer? = nil
        let sql = "SELECT id, name FROM role"
        
        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 1, userInfo: nil)
        }
        
        defer { sqlite3_finalize(statement) }
        
        var roles: [Role] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            roles.append(Role(id: sqlite3_column_int64(statement, 0), name: String(cString: sqlite3_column_text(statement, 1))))
        }
        return roles
    }
    
    func findByUserId(_ id: Int64) throws -> [Role]? {
        var statement: OpaquePointer? = nil
        let sql = "SELECT id, name FROM role INNER JOIN user_role ON role.id = user_role.role_id WHERE user_id = @user_id"
        
        guard sqlite3_prepare(database, sql, -1, &statement, nil) == SQLITE_OK else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 1, userInfo: nil)
        }
               
        defer { sqlite3_finalize(statement) }
                
        guard sqlite3_bind_int64(statement, sqlite3_bind_parameter_index(statement, "@user_id"), id) == SQLITE_OK else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 2, userInfo: nil)
        }
        
        var roles: [Role] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            roles.append(Role(id: sqlite3_column_int64(statement, 0), name: String(cString: sqlite3_column_text(statement, 1))))
        }
        return roles
    }
    
    func updateByUserId(_ id: Int64, roles: [Int64]) throws -> Int32? {
        let values = roles.map { "(\(id), \($0))" }.joined(separator: ", ")
        let sql = "BEGIN TRANSACTION; DELETE FROM user_role WHERE user_id = \(id);" + (values.count > 0 ? "INSERT INTO user_role(user_id, role_id) VALUES\(values);" : "") + "COMMIT;"
        
        guard sqlite3_exec(database, sql, nil, nil, nil) == SQLITE_OK else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 2, userInfo: nil)
        }
        
        return sqlite3_changes(database)
    }
    
}
