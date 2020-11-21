//
//  UserProxyTest.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import EmployeeAdmin

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

    func testAddItem() {
        userProxy.addItem(UserVO(username: "jstooge", first: "Joe", last: "Stooge", email: "joe@stooges.com", password: "abc123", department: DeptEnum.SHIPPING))
        
        XCTAssertEqual(userProxy.users.count, 1)
        
        let userVO = userProxy.users[0]
        XCTAssertEqual(userVO.username, "jstooge")
        XCTAssertEqual(userVO.first, "Joe")
        XCTAssertEqual(userVO.last, "Stooge")
        XCTAssertEqual(userVO.email, "joe@stooges.com")
        XCTAssertEqual(userVO.password, "abc123")
        XCTAssertEqual(userVO.department, DeptEnum.SHIPPING)
    }
    
    func testupdateItem() {
        userProxy.addItem(UserVO(username: "jstooge", first: "Joe", last: "Stooge", email: "joe@stooges.com", password: "abc123", department: DeptEnum.SHIPPING))
        
        userProxy.updateItem(UserVO(username: "jstooge", first: "Joe1", last: "Stooge1", email: "joe1@stooges.com", password: "xyz987", department: DeptEnum.QC))
        let userVO = userProxy.users[0]
        XCTAssertEqual(userVO.username, "jstooge")
        XCTAssertEqual(userVO.first, "Joe1")
        XCTAssertEqual(userVO.last, "Stooge1")
        XCTAssertEqual(userVO.email, "joe1@stooges.com")
        XCTAssertEqual(userVO.password, "xyz987")
        XCTAssertEqual(userVO.department, DeptEnum.QC)
    }
    
    func testDeleteItem() {
        userProxy.addItem(UserVO(username: "jstooge", first: "Joe", last: "Stooge", email: "joe@stooges.com", password: "abc123", department: DeptEnum.SHIPPING))
        userProxy.addItem(UserVO(username: "sstooge", first: "Shemp", last: "Stooge", email: "shemp@stooges.com", password: "xyz987", department: DeptEnum.QC))
        
        userProxy.deleteItem("sstooge")
        XCTAssertEqual(userProxy.users.count, 1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
