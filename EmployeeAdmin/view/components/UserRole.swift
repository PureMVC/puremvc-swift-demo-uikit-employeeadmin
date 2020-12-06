//
//  UserRole.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserRoleDelegate: class {
    func findAllRoles() throws -> [Role]?
    func findRolesById(id: Int64?) throws -> [Role]?
}

protocol UserRoleResponder: class {
    func result(_ roles: [Role]?)
}

class UserRole: UIViewController {
    
    var id: Int64?
    
    var roles: [Role]?
        
    var dataSource: [Role]?
    
    weak var responder: UserRoleResponder?
    
    weak var delegate: UserRoleDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        (UIApplication.shared.delegate as! AppDelegate).registerView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async { [weak self] in // UI Data
            do {
                self?.dataSource = try self?.delegate?.findAllRoles()
                group.leave()
            } catch let error as NSError {
                self?.fault("\(error.localizedDescription), \(error.domain), \(error.code)")
            }
        }
        
        if roles == nil && id != nil { // User Data
            group.enter()
            DispatchQueue.global().async { [weak self] in
                do {
                    self?.roles = try self?.delegate?.findRolesById(id: self?.id)
                    group.leave()
                } catch let error as NSError {
                    self?.fault("\(error.localizedDescription), \(error.domain), \(error.code)")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in // Stitch UI and User Data
            if self?.roles == nil {
                self?.roles = [Role]()
            }
            self?.tableView.reloadData()
        }
    }
    
    func fault(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
        
        if roles?.filter({ $0.id == role?.id }).isEmpty == false {
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
            roles?.append((dataSource?[indexPath.row])!)
            responder?.result(roles)
        } else {
            cell!.accessoryType = UITableViewCell.AccessoryType.none
            roles = roles?.filter {
                $0.id as AnyObject !== dataSource![indexPath.row].id as AnyObject
            }
            responder?.result(roles)
        }
        
    }
}
