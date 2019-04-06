//
//  UserRole.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserRoleDelegate: class {
    func addRole(_ role: RoleEnum)
    func removeRole(_ role: RoleEnum)
}

class UserRole: UITableViewController {
    
    weak var delegate: UserRoleDelegate?
    
    var roles: [RoleEnum]?
    
    // cell content initialize - checkmark/none
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserRoleCell", for: indexPath)
        
        let role = RoleEnum.list[indexPath.row].rawValue
        cell.textLabel?.text = role
        
        if roles?.contains(RoleEnum.list[indexPath.row]) ?? false {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    // cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        
        if cell!.accessoryType == UITableViewCell.AccessoryType.none {
            cell!.accessoryType = UITableViewCell.AccessoryType.checkmark
            delegate?.addRole(RoleEnum.list[indexPath.row])
        } else {
            cell!.accessoryType = UITableViewCell.AccessoryType.none
            delegate?.removeRole(RoleEnum.list[indexPath.row])
        }
    }
    
    // number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoleEnum.list.count
    }

}
