//
//  UserRole.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserRoleDelegate: class {
    func getUserRoles(username: String) -> [RoleEnum]?
}

protocol UserRoleResponder: class {
    func result(_ roles: [RoleEnum])
}

class UserRole: UIViewController {
    
    var username: String?
    
    var roles: [RoleEnum]?
    
    weak var responder: UserRoleResponder?
    
    weak var delegate: UserRoleDelegate?
    
    override func viewDidLoad() {
        (UIApplication.shared.delegate as! AppDelegate).registerView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if roles == nil, let username = username { // roles were not passed, request roles from delegate
            roles = delegate?.getUserRoles(username: username)
        }
        if roles == nil {
            roles = [RoleEnum]()
        }
    }

}

extension UserRole: UITableViewDataSource {
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RoleEnum.list.count
    }
    
    // cell content initialize - checkmark/none
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}

extension UserRole: UITableViewDelegate {
    // cell selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        
        if cell!.accessoryType == UITableViewCell.AccessoryType.none {
            cell!.accessoryType = UITableViewCell.AccessoryType.checkmark
            roles?.append(RoleEnum.list[indexPath.row])
            responder?.result(roles!)
        } else {
            cell!.accessoryType = UITableViewCell.AccessoryType.none
            roles = roles?.filter() { $0 as AnyObject !== RoleEnum.list[indexPath.row] as AnyObject}
            responder?.result(roles!)
        }
    }
}
