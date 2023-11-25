//
//  UserRole.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserRoleDelegate: AnyObject {
    func findAllRoles() throws -> [Role]?
}

protocol UserRoleResponder: AnyObject {
    func result(_ roles: NSSet?)
}

class UserRole: UIViewController {

    var roles: NSSet?
        
    private var dataSource: [Role]?
    
    weak var responder: UserRoleResponder?
    
    weak var delegate: UserRoleDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(view: self);
    }
    
    override func viewWillAppear(_ animated: Bool) {

        DispatchQueue.global().async { [weak self] in // UI Data
            do {
                self?.dataSource = try self?.delegate?.findAllRoles()
            } catch let error as NSError {
                self?.fault("\(error.localizedDescription), \(error.domain), \(error.code)")
            }
        }
        
        if roles == nil { // User Data
            roles = NSSet()
        }

        tableView.reloadData()
    }
    
    func fault(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}

extension UserRole: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // number of rows
        dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // cell content initialize - checkmark/none
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserRoleCell", for: indexPath)
        
        let role = dataSource?[indexPath.row]
        cell.textLabel?.text = role?.name

        if roles?.filter({ $0 as? Role == role }).isEmpty == false {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
}

extension UserRole: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // cell selected
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        
        if cell!.accessoryType == UITableViewCell.AccessoryType.none {
            cell!.accessoryType = UITableViewCell.AccessoryType.checkmark
            if let existing = roles as? Set<Role>, let role = dataSource?[indexPath.row] {
                roles = NSSet(set: existing.union([role]))
            }
            responder?.result(roles)
        } else {
            cell!.accessoryType = UITableViewCell.AccessoryType.none
            if let existing = roles as? Set<Role>, let role = dataSource?[indexPath.row] {
                roles = NSSet(set: existing.subtracting([role]))
            }
            responder?.result(roles)
        }
        
    }
}
