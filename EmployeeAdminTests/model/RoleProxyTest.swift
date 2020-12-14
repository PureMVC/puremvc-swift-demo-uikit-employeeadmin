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

class RoleProxyTest: XCTestCase {

    var userProxy: UserProxy!
    var roleProxy: RoleProxy!
            
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        roleProxy = RoleProxy(session: URLSession.shared)
        userProxy = UserProxy(session: URLSession.shared)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFindAll() {
        let e = expectation(description: "testFindAll")
        
        roleProxy.findAll { (roles, exception) in
            
            guard let roles = roles else {
                XCTFail(exception!.description)
                e.fulfill()
                return
            }
            
            XCTAssertEqual(roles.count, 14)
            roles.forEach { role in
                XCTAssertNotNil(role.id)
                XCTAssertNotNil(role.name)
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFindByUserId() {
        let e = expectation(description: "testFindbyUserId")
        
        roleProxy.findByUserId(2) { (roles, exception) in
            guard let roles = roles else {
                XCTFail(exception!.description)
                e.fulfill()
                return
            }
            
            XCTAssertEqual(roles.count, 3)
            roles.forEach { role in
                XCTAssertNotNil(role.id)
                XCTAssertNotNil(role.name)
            }
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testUpdateByUserId() {
        let e = expectation(description: "testUpdatebyUserId")
        
        roleProxy.updateByUserId(1, roles: [Role(id: 4, name: "Employee Benefits"), Role(id: 5, name: "General Ledger"), Role(id: 6, name: "Payroll")]) { [weak self] (ids, exception) in
            
            guard let ids = ids else {
                XCTFail(exception!.description)
                e.fulfill()
                return
            }
            
            XCTAssertEqual(ids.count, 3)
            
            self?.roleProxy.findByUserId(1) { (roles, ex) in // confirmation
                guard let roles = roles else {
                    XCTFail(ex!.description)
                    e.fulfill()
                    return
                }
                XCTAssertEqual(roles.count, 3)
                
                // reset
                self?.roleProxy.updateByUserId(1, roles: [Role(id: 4, name: "Employee Benefits")]) { (_, _) in
                    e.fulfill()
                }
            }
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
