//
//  UserProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

class UserProxy: Proxy {
    
    override class var NAME: String { return "UserProxy" }
    
    init() {
        super.init(proxyName: UserProxy.NAME, data: [UserVO]())
    }
    
    // add an item to the data
    func addItem(item: Any) {
        var users = data as! [UserVO]
        users.append(item as! UserVO)
        data = users
    }
    
    // update an item in the data
    func updateItem(item: Any) {
        let user = item as! UserVO
        var users = data as! [UserVO]
        for (index, element) in users.enumerate() {
            if (element.username == user.username) {
                users[index] = user
                data = users
                break
            }
        }
    }
    
    // delete an item in the data
    func deleteItem(item: Any) {
        let user = item as! UserVO
        var users = data as! [UserVO]
        for (index, element) in users.enumerate() {
            if (element.username == user.username) {
                users.removeAtIndex(index)
                data = users
                break
            }
        }
    }
    
    var users: [UserVO] {
        return data as! [UserVO]
    }
    
}
