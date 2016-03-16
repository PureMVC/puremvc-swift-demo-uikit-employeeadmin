//
//  UserList.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit
import PureMVC

protocol UserListDelegate: class {
    func onNew()
    func onDelete(userVO: UserVO)
    func onSelect(userVO: UserVO)
}

class UserList: UITableViewController {
    
    weak var _delegate: UserListDelegate?
    
    var users: [UserVO]?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "onNew")
    }
    
    // show details of the user
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.onSelect(users![indexPath.row])
    }
    
    // add user to the tableView
    func add(userVO: UserVO) {
        if users != nil {
            users!.append(userVO)
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: users!.count-1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // update user in the tableView
    func update(userVO: UserVO) {
        for (index, element) in (users!).enumerate() {
            if userVO.username == element.username {
                users![index] = userVO
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
                cell?.textLabel?.text = userVO.givenName
                break
            }
        }
    }
    
    // delete user from the tableView
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            delegate?.onDelete(users![indexPath.row])
            users!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // add new user
    func onNew() {
        delegate?.onNew()
    }
    
    // number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users != nil ? users!.count : 0
    }
    
    // cell contents
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserListCell", forIndexPath: indexPath) 
        cell.textLabel?.text = users![indexPath.row].givenName
        return cell
    }
    
    var delegate: UserListDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
}