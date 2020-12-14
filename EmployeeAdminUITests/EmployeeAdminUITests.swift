//
//  EmployeeAdminUITests.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import EmployeeAdmin

class EmployeeAdminUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testList() { // disable hardware keyboard
        let app = XCUIApplication()
        XCTAssertEqual(app.tables.staticTexts.count, 3)
        app.tables.cells.element(boundBy: 0).tap()
    }
    
    func testLarry() {
        let app = XCUIApplication()

        app.tables.cells.element(boundBy: 0).tap()

        XCTAssertEqual(app.textFields["First Name"].value as! String, "Larry")
        XCTAssertEqual(app.textFields["Last Name"].value as! String, "Stooge")
        XCTAssertEqual(app.textFields["Email"].value as! String, "larry@stooges.com")
        XCTAssertFalse(app.textFields["Username"].isEnabled)
        XCTAssertEqual(app.textFields["Username"].value as! String, "lstooge")
        XCTAssertNotEqual((app.secureTextFields["Password"].value as! String).count, 0)
        XCTAssertNotEqual((app.secureTextFields["Confirm"].value as! String).count, 0)
        XCTAssertEqual(app.pickerWheels.element.value as! String, "Accounting")

        app.navigationBars["Profile"].buttons["Users"].tap()
    }
    
    func testCurly() { // disable hardware keyboard
        let app = XCUIApplication()
        app.tables.cells.element(boundBy: 1).tap()

        // update roles
        app.tables.cells.staticTexts["User Roles"].tap()
        app.tables.cells.element(boundBy: 0).tap();
        app.navigationBars["UserRole"].buttons["Profile"].tap() // back from user role

        // update details
        app.textFields["First Name"].tap(); app.textFields["First Name"].typeText("1")
        app.textFields["Last Name"].tap(); app.textFields["Last Name"].typeText("1")
        app.textFields["Email"].tap(); app.textFields["Email"].typeText("1")
        XCTAssertFalse(app.textFields["Username"].isEnabled)
        app.pickerWheels.element.adjust(toPickerWheelValue: "Accounting")
        app.navigationBars["Profile"].buttons["Save"].tap() // save

        // Select Curly
        _ = app.tables.cells.element(boundBy: 1).waitForExistence(timeout: 1)
        app.tables.cells.element(boundBy: 1).tap()

        // verify roles
        app.tables.cells.staticTexts["User Roles"].tap()
        _ = app.tables.cells.element(boundBy: 1).waitForExistence(timeout: 1)
         XCTAssertEqual(app.tables.cells.element(boundBy: 0).isSelected, true)
        app.navigationBars["UserRole"].buttons["Profile"].tap() // back from user role

        // verify details
        XCTAssertEqual(app.textFields["First Name"].value as! String, "Curly1")
        XCTAssertEqual(app.textFields["Last Name"].value as! String, "Stooge1")
        XCTAssertEqual(app.textFields["Email"].value as! String, "curly@stooges1.com")
        XCTAssertFalse(app.textFields["Username"].isEnabled)
        XCTAssertEqual(app.pickerWheels.element.value as! String, "Accounting")
        app.navigationBars["Profile"].buttons["Users"].tap() // back from user form without saving
    }
    
    func testNewUser() {
        let app = XCUIApplication()
        app.navigationBars["Users"].buttons["Add"].tap()
        
        // select roles
        app.tables.cells.staticTexts["User Roles"].tap()
        app.tables.cells.element(boundBy: 0).tap();
        app.tables.cells.element(boundBy: 1).tap();
        app.navigationBars["UserRole"].buttons["Profile"].tap() // back from user role
        
        // enter details
        app.textFields["First Name"].tap(); app.textFields["First Name"].typeText("Joe")
        app.textFields["Last Name"].tap(); app.textFields["Last Name"].typeText("Stooge")
        app.textFields["Email"].tap(); app.textFields["Email"].typeText("joe@stooges.com")
        XCTAssertTrue(app.textFields["Username"].isEnabled)
        app.textFields["Username"].tap(); app.textFields["Username"].typeText("jstooge")
        app.secureTextFields["Password"].tap(); app.secureTextFields["Password"].typeText("abc123\n") // Dismiss keyboard by \n to get rid of the strong password autofill
        app.secureTextFields["Confirm"].tap(); app.secureTextFields["Confirm"].typeText("abc123\n")
        app.pickerWheels.element.adjust(toPickerWheelValue: "Shipping")
        app.navigationBars["Profile"].buttons["Save"].tap()
        
        // verify new record
        _ = app.tables.cells.element(boundBy: 3).waitForExistence(timeout: 1)
        app.tables.cells.element(boundBy: 3).tap()
        
        // verify roles
        app.tables.cells.staticTexts["User Roles"].tap()
        _ = app.tables.cells.element(boundBy: 1).waitForExistence(timeout: 1)
        XCTAssertEqual(app.tables.cells.element(boundBy: 0).isSelected, true)
        XCTAssertEqual(app.tables.cells.element(boundBy: 1).isSelected, true)
        app.navigationBars["UserRole"].buttons["Profile"].tap() // back from user role
        
        // verify input data
        XCTAssertEqual(app.textFields["First Name"].value as! String, "Joe")
        XCTAssertEqual(app.textFields["Last Name"].value as! String, "Stooge")
        XCTAssertEqual(app.textFields["Email"].value as! String, "joe@stooges.com")
        XCTAssertFalse(app.textFields["Username"].isEnabled)
        XCTAssertEqual(app.textFields["Username"].value as! String, "jstooge")
        XCTAssertEqual(app.pickerWheels.element.value as! String, "Shipping")
        app.navigationBars["Profile"].buttons["Users"].tap() // back from user form without saving
        
        // delete user
        XCTAssertEqual(app.tables.staticTexts.count, 4)
        app.tables.cells.element(boundBy: 3).swipeLeft()
        app.tables.cells.element(boundBy: 3).buttons["Delete"].tap()
        XCTAssertEqual(app.tables.staticTexts.count, 3)
    }
    
    func testNewUserWithoutRoles() {
        let app = XCUIApplication()
        app.navigationBars["Users"].buttons["Add"].tap()
        
        // enter details
        app.textFields["First Name"].tap(); app.textFields["First Name"].typeText("Shemp")
        app.textFields["Last Name"].tap(); app.textFields["Last Name"].typeText("Stooge")
        app.textFields["Email"].tap(); app.textFields["Email"].typeText("shemp@stooges.com")
        XCTAssertTrue(app.textFields["Username"].isEnabled)
        app.textFields["Username"].tap(); app.textFields["Username"].typeText("sshemp")
        app.secureTextFields["Password"].tap(); app.secureTextFields["Password"].typeText("xyz987\n"); // Dismiss keyboard by \n to get rid of the strong password autofill
        app.secureTextFields["Confirm"].tap(); app.secureTextFields["Confirm"].typeText("xyz987\n");
        app.pickerWheels.element.adjust(toPickerWheelValue: "Accounting")
        app.navigationBars["Profile"].buttons["Save"].tap()
        
        // verify new record
        _ = app.tables.cells.element(boundBy: 3).waitForExistence(timeout: 1)
        XCTAssertEqual(app.tables.staticTexts.count, 4)
        app.tables.cells.element(boundBy: 3).tap()
        
        // select roles
        app.tables.cells.staticTexts["User Roles"].tap()
        _ = app.tables.cells.element(boundBy: 1).waitForExistence(timeout: 1)
        app.tables.cells.element(boundBy: 0).tap();
        app.tables.cells.element(boundBy: 1).tap();
        app.navigationBars["UserRole"].buttons["Profile"].tap() // back from user role
        app.navigationBars["Profile"].buttons["Save"].tap() // save
        
        // verify roles
        app.tables.cells.element(boundBy: 3).tap()
        app.tables.cells.staticTexts["User Roles"].tap()
        _ = app.tables.cells.element(boundBy: 1).waitForExistence(timeout: 1)
        XCTAssertEqual(app.tables.cells.element(boundBy: 0).isSelected, true)
        XCTAssertEqual(app.tables.cells.element(boundBy: 1).isSelected, true)
        app.navigationBars["UserRole"].buttons["Profile"].tap() // back from user role
        app.navigationBars["Profile"].buttons["Users"].tap()
        
        // delete user
        XCTAssertEqual(app.tables.staticTexts.count, 4)
        app.tables.cells.element(boundBy: 3).swipeLeft()
        app.tables.cells.element(boundBy: 3).buttons["Delete"].tap()
        XCTAssertEqual(app.tables.staticTexts.count, 3)
    }
    
    func testInvalidEntry() {
        let app = XCUIApplication()
        app.navigationBars["Users"].buttons["Add"].tap()

        app.navigationBars["Profile"].buttons["Save"].tap() // save

        XCTAssertEqual(app.alerts.element.label, "Error")
        XCTAssert(app.alerts.element.staticTexts["Invalid Form Data."].exists)
    }

    func testInvalidPassword() {
        let app = XCUIApplication()
        app.navigationBars["Users"].buttons["Add"].tap()

        app.secureTextFields["Password"].tap(); app.secureTextFields["Password"].typeText("abc123")
        app.secureTextFields["Confirm"].tap(); app.secureTextFields["Confirm"].typeText("ijk456\n")

        app.navigationBars["Profile"].buttons["Save"].tap() // save

        XCTAssertEqual(app.alerts.element.label, "Error")
        XCTAssert(app.alerts.element.staticTexts["Invalid Form Data."].exists)
    }

}
