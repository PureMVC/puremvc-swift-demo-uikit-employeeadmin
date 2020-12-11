//
//  UserProxyTest.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import EmployeeAdmin
import Foundation
import SQLite3

class UserProxyTest: XCTestCase {
    
    var userProxy: UserProxy!
    
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
        userProxy = UserProxy(database!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        userProxy = nil
        sqlite3_close(database)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Could not delete file: \(error)")
        }
    }
    
    func testFindAll() {
        do {
            if let users = try userProxy.findAll() {
                XCTAssertEqual(users.count, 3)
                XCTAssertEqual(users[0].id, 1)
                XCTAssertEqual(users[0].first!, "Larry")
                XCTAssertEqual(users[0].last!, "Stooge")
            }
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func testFindById() {
        do {
            if let user = try userProxy.findById(1) {
                XCTAssertEqual(user.username!, "lstooge")
                XCTAssertEqual(user.first!, "Larry")
                XCTAssertEqual(user.last!, "Stooge")
                XCTAssertEqual(user.email!, "larry@stooges.com")
                XCTAssertEqual(user.password!, "ijk456")
                XCTAssertEqual(user.department!.id, 1)
            }
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func testFindByInvalidId() {
        do {
            if let _ = try userProxy.findById(100) {
                XCTFail("There shouldn't be any user by this id")
            }
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func testSave() {
        do {
            let user = User(id: 0, username: "jstooge", first: "Joe", last: "Stooge", email: "joe@stooges.com", password: "abc123", department: Department(id: 3, name: "Shipping"))
            
            if let id = try userProxy.save(user) {
                XCTAssertNotNil(id)
            }
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func testUpdate() {
        do {
            let user = User(id: 1, username: nil, first: "Larry1", last: "Stooge1", email: "larry1@stooges.com", password: "abc123", department: Department(id: 3, name: "Shipping"))
            
            if let modified = try userProxy.update(user) {
                XCTAssertEqual(modified, 1)
                
                if let updated = try userProxy.findById(1) {
                    XCTAssertEqual(updated.first!, "Larry1")
                    XCTAssertEqual(updated.last!, "Stooge1")
                    XCTAssertEqual(updated.email!, "larry1@stooges.com")
                    XCTAssertEqual(updated.password!, "abc123")
                    XCTAssertEqual(updated.department!.id, 3)
                }
            }
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func testDelete() {
        do {
            if let modified = try userProxy.deleteById(1) {
                XCTAssertEqual(modified, 1)
            }
            if let _ = try userProxy.findById(1) {
                XCTFail("User should have been deleted")
            }
        } catch let error as NSError {
            XCTFail(error.description)
        }
    }
    
    func testFindAllDepartments() {
        do {
            if let departments = try userProxy.findAllDepartments() {
                XCTAssertEqual(departments.count, 5)
                departments.forEach { department in
                    XCTAssertNotNil(department.id)
                    XCTAssertNotNil(department.name)
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
