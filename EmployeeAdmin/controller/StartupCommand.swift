//
//  StartupCommand.swift
//  PureMVC SWIFT Demo - userAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation
import SQLite3
import UIKit

class StartupCommand: SimpleCommand {
    
    override func execute(_ notification: INotification) {
        

        
        var database: OpaquePointer? = nil
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("employeeadmin.sqlite")
        
        let window = notification.body as? UIWindow
        let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        alert.message = "hello world"
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        })
                
        if FileManager.default.fileExists(atPath: url.path) == false { // Initialize (One time)
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
                    alert.message = error.description
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        window?.rootViewController?.present(alert, animated: true, completion: nil)
                    })
                }
            } else {
                alert.message = String(cString: sqlite3_errmsg(database))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    window?.rootViewController?.present(alert, animated: true, completion: nil)
                })
            }
        } else if sqlite3_open_v2(url.path, &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK { // Existing database (Serialized mode)
            do {
                guard sqlite3_exec(database, "PRAGMA foreign_keys = ON", nil, nil, nil) == SQLITE_OK else {
                    throw NSError(domain: String(cString: sqlite3_errmsg(database)), code: 2, userInfo: nil)
                }
            } catch let error as NSError {
                alert.message = error.description
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    window?.rootViewController?.present(alert, animated: true, completion: nil)
                })
            }
        } else { // Error opening database
            alert.message = String(cString: sqlite3_errmsg(database))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                window?.rootViewController?.present(alert, animated: true, completion: nil)
            })
        }

        facade.registerProxy(UserProxy(database!))
        facade.registerProxy(RoleProxy(database!))
    }
    
}
