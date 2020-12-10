//
//  RoleProxyTest.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import EmployeeAdmin
import Foundation
import SQLite3

class RoleProxyTest: XCTestCase {

    var userProxy: UserProxy!
    var roleProxy: RoleProxy!
    
    var database: OpaquePointer? = nil
    
    let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("employeeadmin_test.sqlite")
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if FileManager.default.fileExists(atPath: url.path) == false {
            if sqlite3_open_v2(url.path, &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK { // Serialized mode
                do {
                    guard
                        sqlite3_exec(database, "PRAGMA foreign_keys = ON", nil, nil, nil) == SQLITE_OK &&
                            
                        sqlite3_exec(database, "CREATE TABLE department(id INTEGER PRIMARY KEY, name TEXT NOT NULL)", nil, nil, nil) == SQLITE_OK &&
                        sqlite3_exec(database, "INSERT INTO department(id, name) VALUES(1, 'Accounting'), (2, 'Sales'), (3, 'Plant'), (4, 'Shipping'), (5, 'Quality Control')", nil, nil, nil) == SQLITE_OK &&
                            
                        sqlite3_exec(database, "CREATE TABLE role(id INTEGER PRIMARY KEY, name TEXT NOT NULL)", nil, nil, nil) == SQLITE_OK &&
                        sqlite3_exec(database, "INSERT INTO role(id, name) VALUES(1, 'Administrator'), (2, 'Accounts Payable'), (3, 'Accounts Receivable'), (4, 'Employee Benefits'), (5, 'General Ledger'),(6, 'Payroll'), (7, 'Inventory'), (8, 'Production'), (9, 'Quality Control'), (10, 'Sales'), (11, 'Orders'), (12, 'Customers'), (13, 'Shipping'), (14, 'Returns')", nil, nil, nil) == SQLITE_OK &&
                    
                        sqlite3_exec(database, "CREATE TABLE user(id INTEGER PRIMARY KEY, username TEXT NOT NULL UNIQUE, first TEXT NOT NULL, last TEXT NOT NULL, email TEXT NOT NULL, password TEXT NOT NULL, department_id INTEGER NOT NULL, FOREIGN KEY(department_id) REFERENCES department(id) ON DELETE CASCADE ON UPDATE NO ACTION)", nil, nil, nil) == SQLITE_OK &&
                        sqlite3_exec(database, "INSERT INTO user(id, username, first, last, email, password, department_id) VALUES(1, 'lstooge', 'Larry', 'Stooge', 'larry@stooges.com', 'ijk456', 1), (2, 'cstooge', 'Curly', 'Stooge', 'curly@stooges.com', 'xyz987', 2), (3, 'mstooge', 'Moe', 'Stooge', 'moe@stooges.com', 'abc123', 3)", nil, nil, nil) == SQLITE_OK &&
                    
                        sqlite3_exec(database, "CREATE TABLE user_role(user_id INTEGER NOT NULL, role_id INTEGER NOT NULL, PRIMARY KEY(user_id, role_id), FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE NO ACTION, FOREIGN KEY(role_id) REFERENCES role(id) ON DELETE CASCADE ON UPDATE NO ACTION)", nil, nil, nil) == SQLITE_OK &&
                        sqlite3_exec(database, "INSERT INTO user_role(user_id, role_id) VALUES(1, 4), (2, 3), (2, 5), (3, 8), (3, 10), (3, 13)", nil, nil, nil) == SQLITE_OK
                    else {
                        throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 2, userInfo: nil)
                    }
                } catch let error as NSError  {
                    print(error.description)
                }
            } else {
                print(String(cString: sqlite3_errmsg(database)))
            }
        } else if sqlite3_open(url.path, &database) != SQLITE_OK {
            print(String(cString: sqlite3_errmsg(database)))
        }
        roleProxy = RoleProxy(database!)
        userProxy = UserProxy(database!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        roleProxy = nil
        sqlite3_close(database)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Could not delete file: \(error)")
        }
    }
    
    func testFindAll() {
        do {
            if let roles = try roleProxy.findAll() {
                XCTAssertEqual(roles.count, 14)
                roles.forEach { role in
                    XCTAssertNotNil(role.id)
                    XCTAssertNotNil(role.name)
                }
            }
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func testFindByUserId() {
        do {
            if let roles = try roleProxy.findByUserId(2) {
                XCTAssertEqual(roles.count, 2)
                roles.forEach { role in
                    XCTAssertNotNil(role.id)
                    XCTAssertNotNil(role.name)
                }
            }
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func testDeleteAndFindRolesById() { 
//        do {
//            if let modified = try userProxy.deleteById(2) {
//                XCTAssertEqual(modified, 1)
//
//                if let roles = try roleProxy.findByUserId(2) {
//                    XCTAssertEqual(roles.count, 0)
//                }
//            }
//        } catch let error as NSError {
//            XCTFail(error.description)
//        }
    }

    func testUpdateByUserId() {
        do {
            if let modified = try roleProxy.updateByUserId(1, roles: [4, 5, 6]) {
                XCTAssertEqual(modified, 3)
                
                if let roles = try roleProxy.findByUserId(1) {
                    XCTAssertEqual(roles.count, 3)
                }
            }
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
