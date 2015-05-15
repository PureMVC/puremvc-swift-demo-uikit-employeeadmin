//
//  UserRole.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit
import PureMVC

protocol UserRoleDelegate: class {
    func onAdd(userVO: UserVO, role: RoleEnum)
    func onDelete(userVO: UserVO, role: RoleEnum)
    func doesUserHaveRole(userVO: UserVO, role: RoleEnum) -> Bool
}

class UserRole: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var _delegate: UserRoleDelegate?
    
    var userVO: UserVO?
    var selectedRole: RoleEnum?
    var userRoles: [RoleEnum]?
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell!.accessoryType == UITableViewCellAccessoryType.None {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            delegate?.onAdd(userVO!, role: RoleEnum.list[indexPath.row])
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
            delegate?.onDelete(userVO!, role: RoleEnum.list[indexPath.row])
        }
    }
    
    // number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoleEnum.list.count
    }
    
    // cell content - checkmark/none
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserRoleCell", forIndexPath: indexPath) as! UITableViewCell
        
        var role = RoleEnum.list[indexPath.row].value
        cell.textLabel?.text = role
        
        if delegate!.doesUserHaveRole(userVO!, role: RoleEnum.list[indexPath.row]) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }

    var delegate: UserRoleDelegate? {
        get { return _delegate }
        set { _delegate = newValue }
    }
}