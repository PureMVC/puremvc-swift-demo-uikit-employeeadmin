//
//  UserProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class UserProxy: Proxy {
    
    override class var NAME: String { return "UserProxy" }
    
    init() {
        super.init(name: UserProxy.NAME, data: [UserVO]())
    }
    
    // add an item to the data
    func addItem(_ item: UserVO) {
        var users = data as! [UserVO]
        users.append(item)
        data = users
    }
    
    // update an item in the data
    func updateItem(_ item: Any) {
        let user = item as! UserVO
        var users = data as! [UserVO]
        for (index, element) in users.enumerated() {
            if (element.username == user.username) {
                users[index] = user
                data = users
                break
            }
        }
    }
    
    // delete an item in the data
    func deleteItem(_ username: String) {
        var users = data as! [UserVO]
        for (index, element) in users.enumerated() {
            if (element.username == username) {
                users.remove(at: index)
                data = users
                break
            }
        }
    }
    
    var users: [UserVO] {
        return data as! [UserVO]
    }
    
}
