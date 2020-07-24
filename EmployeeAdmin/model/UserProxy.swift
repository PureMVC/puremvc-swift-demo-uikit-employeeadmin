//
//  UserProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class UserProxy: Proxy {
    
    override class var NAME: String { "UserProxy" }
    
    init() {
        super.init(name: UserProxy.NAME, data: [UserVO]())
    }
    
    // add an item to the data
    func addItem(_ item: UserVO) {
        users.append(item)
    }
    
    // update an item in the data
    func updateItem(_ user: UserVO) {
        for (index, element) in users.enumerated() {
            if (element.username == user.username) {
                users[index] = user
                break
            }
        }
    }
    
    // delete an item in the data
    func deleteItem(_ username: String) {
        for (index, element) in users.enumerated() {
            if (element.username == username) {
                users.remove(at: index)
                break
            }
        }
    }
    
    var users: [UserVO] {
        get { data as! [UserVO] }
        set { data = newValue }
    }
    
}
