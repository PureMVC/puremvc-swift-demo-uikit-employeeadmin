//
//  RoleProxyTest.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import EmployeeAdmin

class RoleProxyTest: XCTestCase {

    var roleProxy: RoleProxy!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        roleProxy = RoleProxy()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        roleProxy = nil
    }

    func testAddItem() {
        roleProxy.addItem(RoleVO(username: "jstooge", roles: [.SALES, .RETURNS, .SHIPPING]))
        
        XCTAssertEqual(roleProxy.roles.count, 1)
    }
    
    func testGetRoleVO() {
        roleProxy.addItem(RoleVO(username: "jstooge", roles: [.SALES, .RETURNS, .SHIPPING]))
        
        let roles = roleProxy.getUserRoles("jstooge")!
        XCTAssertEqual(roles.count, 3)
        XCTAssertEqual(roles[0], .SALES)
        XCTAssertEqual(roles[1], .RETURNS)
        XCTAssertEqual(roles[2], .SHIPPING)
    }
    
    func testUpdateUserRoles() {
        roleProxy.addItem(RoleVO(username: "jstooge", roles: [.SALES, .RETURNS, .SHIPPING]))
        roleProxy.addItem(RoleVO(username: "sstooge", roles: [.ADMIN, .ACCT_PAY]))
        
        roleProxy.updateUserRoles(username: "sstooge", role: [.RETURNS])
        let roles = roleProxy.getUserRoles("sstooge")!
        
        XCTAssertEqual(roles.count, 1)
        XCTAssertEqual(roles[0], .RETURNS)
    }
    
    func testDeleteItem() {
        roleProxy.addItem(RoleVO(username: "jstooge", roles: [.SALES, .RETURNS, .SHIPPING]))
        roleProxy.addItem(RoleVO(username: "sstooge", roles: [.ADMIN, .ACCT_PAY]))
        
        roleProxy.deleteItem("sstooge")
        XCTAssertNil(roleProxy.getUserRoles("sstooge"))
        XCTAssertEqual(roleProxy.roles.count, 1)
        
        roleProxy.deleteItem("jstooge")
        XCTAssertNil(roleProxy.getUserRoles("jstooge"))
        XCTAssertEqual(roleProxy.roles.count, 0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
