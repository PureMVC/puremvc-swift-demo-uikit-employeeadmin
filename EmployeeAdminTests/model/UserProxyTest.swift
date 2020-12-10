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

class UserProxyTest: XCTestCase {
    
    var userProxy: UserProxy!
        
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        userProxy = UserProxy()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        userProxy = nil
    }
    
    func testFindAll() {
        let e = expectation(description: "testGetUsers")

        userProxy.findAll { users, exception in
            
            guard let users = users else {
                XCTFail(exception!.description)
                e.fulfill()
                return
            }
            
            XCTAssertEqual(users.count, 3)
            XCTAssertEqual(users[0].username!, "lstooge")
            XCTAssertEqual(users[0].first!, "Larry")
            XCTAssertEqual(users[0].last!, "Stooge")
            XCTAssertEqual(users[0].email!, "larry@stooges.com")
            XCTAssertNil(users[0].password)
            XCTAssertEqual(users[0].department!.id, 1)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFindById() {
        let e = expectation(description: "testFindbyId")
        
        userProxy.findById(1) { user, exception in
            if (exception != nil) {
                XCTFail(exception?.description ?? "Error")
            } else if let user = user {
                XCTAssertEqual(user.username!, "lstooge")
                XCTAssertEqual(user.first!, "Larry")
                XCTAssertEqual(user.last!, "Stooge")
                XCTAssertEqual(user.email!, "larry@stooges.com")
                XCTAssertNil(user.password)
                XCTAssertEqual(user.department!.id, 1)
            } else {
                XCTFail("User not Found")
            }

            e.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFindByInvalidId() {
        let e = expectation(description: "testFindByInvalidId")
        
        userProxy.findById(100) { user, exception in
            if let _ = user {
                XCTFail("There shouldn't be any user by this id")
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSave() {
        let e = expectation(description: "testSave")
                
        let user = User(id: 0, username: "jstooge", first: "Joe", last: "Stooge", email: "joe@stooges.com", password: "abc123", department: Department(id: 3, name: "Shipping"))
        userProxy.save(user) { id, exception in
            
            guard let id = id else {
                XCTFail(exception!.description)
                e.fulfill()
                return
            }
            
            XCTAssertNotNil(id)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUpdate() {
        let e = expectation(description: "testSave")
        
        let user = User(id: nil, username: nil, first: "Larry1", last: "Stooge1", email: "larry1@stooges.com", password: "abc123", department: Department(id: 3, name: "Shipping"))
        
        userProxy.update(user) { [weak self] (modified, exception) in
        
            self?.userProxy.findById(1) { updated, exception in
                XCTAssertNotNil(exception)
                XCTAssertEqual(updated!.first!, "Larry1")
                XCTAssertEqual(updated!.last!, "Stooge1")
                XCTAssertEqual(updated!.email!, "larry1@stooges.com")
                XCTAssertEqual(updated!.password!, "abc123")
                XCTAssertEqual(updated!.department!.id, 3)
            }
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testDeleteById() {
        let e = expectation(description: "testDeleteById")
        
        userProxy.deleteById(40) { modified, exception in
            
            guard let modified = modified else {
                XCTFail(exception!.description)
                e.fulfill()
                return
            }
            
            XCTAssertEqual(modified, 1)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFindAllDepartments() {
        let e = expectation(description: "testFindAllDepartments")
        
        userProxy.findAllDepartments { departments, exception in
            
            guard let departments = departments else {
                XCTFail(exception!.description)
                e.fulfill()
                return
            }
            
            XCTAssertEqual(departments.count, 5)
            
            departments.forEach { department in
                XCTAssertNotNil(department.id)
                XCTAssertNotNil(department.name)
            }
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
