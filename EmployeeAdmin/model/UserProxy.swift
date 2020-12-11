//
//  UserProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation
import SQLite3

class UserProxy: Proxy {
       
    override class var NAME: String { "UserProxy" }
    
    internal var database: OpaquePointer! = nil
    
    init(_ database: OpaquePointer) {
        super.init(name: UserProxy.NAME, data: [User]())
        self.database = database
    }
    
    func findAll() throws -> [User]? {
        var statement: OpaquePointer? = nil
        let sql = "SELECT id, first, last FROM user"
        
        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 1, userInfo: nil)
        }
        
        defer { sqlite3_finalize(statement) }
        
        var users: [User] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            users.append(User(id: sqlite3_column_int64(statement, 0), username: nil, first: String(cString: sqlite3_column_text(statement, 1)),
                              last: String(cString: sqlite3_column_text(statement, 2)), email: nil, password: nil, department: nil))
        }
        return users
    }
    
    func findById(_ id: Int64) throws -> User? {
        var statement: OpaquePointer? = nil
        let sql = "SELECT user.*, department.name AS 'department_name' FROM user INNER JOIN department ON user.department_id = department.id WHERE user.id = @id"
        
        guard sqlite3_prepare(database, sql, -1, &statement, nil) == SQLITE_OK else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 1, userInfo: nil)
        }
        
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_int64(statement, sqlite3_bind_parameter_index(statement, "@id"), id) == SQLITE_OK else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 2, userInfo: nil)
        }
        
        if sqlite3_step(statement) == SQLITE_ROW {
            return User(id: sqlite3_column_int64(statement, 0), username: String(cString: sqlite3_column_text(statement, 1)),
                        first: String(cString: sqlite3_column_text(statement, 2)), last: String(cString: sqlite3_column_text(statement, 3)),
                        email: String(cString: sqlite3_column_text(statement, 4)), password: String(cString: sqlite3_column_text(statement, 5)),
                        department: Department(id: sqlite3_column_int64(statement, 6), name: String(cString: sqlite3_column_text(statement, 7))))
        } else {
            return nil
        }
    }
    
    func save(_ user: User) throws -> Int64? {
        var statement: OpaquePointer? = nil
        let sql = "INSERT INTO user(username, first, last, email, password, department_id) VALUES(@username, @first, @last, @email, @password, @department_id)"
        
        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 1, userInfo: nil)
        }
        
        defer { sqlite3_finalize(statement) }
        
        guard
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, "@username"), ((user.username ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, "@first"), ((user.first ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, "@last"), ((user.last ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, "@email"), ((user.email ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, "@password"), ((user.password ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int64(statement, sqlite3_bind_parameter_index(statement, "@department_id"), user.department?.id ?? -1) == SQLITE_OK
        else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 2, userInfo: nil)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 3, userInfo: nil)
        }
        let id = sqlite3_last_insert_rowid(database)
        return id
    }
    
    func update(_ user: User) throws -> Int32? {
        var statement: OpaquePointer? = nil
        let sql = "UPDATE user SET first = @first, last = @last, email = @email, password = @password, department_id = @department_id WHERE id = @id"
        
        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 1, userInfo: nil)
        }
        
        defer { sqlite3_finalize(statement) }
        
        guard
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, "@first"), ((user.first ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, "@last"), ((user.last ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, "@email"), ((user.email ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statement, sqlite3_bind_parameter_index(statement, "@password"), ((user.password ?? "") as NSString).utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int64(statement, sqlite3_bind_parameter_index(statement, "@department_id"), user.department?.id ?? -1) == SQLITE_OK &&
            sqlite3_bind_int64(statement, sqlite3_bind_parameter_index(statement, "@id"), user.id ?? 0) == SQLITE_OK
        else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 2, userInfo: nil)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 3, userInfo: nil)
        }
        
        return sqlite3_changes(database)
    }
    
    func deleteById(_ id: Int64) throws -> Int32? {
        let sql = "DELETE FROM user WHERE id = \(id)"
        
        guard sqlite3_exec(database, sql, nil, nil, nil) == SQLITE_OK else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 1, userInfo: nil)
        }
        
        return sqlite3_changes(database)
    }
    
    func findAllDepartments() throws -> [Department]? {
        var statement: OpaquePointer? = nil
        let sql = "SELECT id, name FROM department"
        
        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK else {
            throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 1, userInfo: nil)
        }
        
        defer { sqlite3_finalize(statement) }
        
        var departments: [Department] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            departments.append(Department(id: sqlite3_column_int64(statement, 0), name: String(cString: sqlite3_column_text(statement, 1))))
        }
        return departments
    }
    
}
