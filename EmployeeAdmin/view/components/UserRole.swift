//
//  UserRole.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserRoleDelegate: AnyObject {
    func findAllRoles() async throws -> [Role]
    func findRolesByUser(_ user: User) async throws -> [Role]
}

class UserRole: UIViewController {
    
    var user: User?
            
    private var roles: [Role]?
    
    var responder: ((User?) -> Void)?
        
    weak var delegate: UserRoleDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(view: self)
        
        guard let user, let delegate else { return }
        
        Task {
            do {
                let (roles, userRoles) = try await(delegate.findAllRoles(),
                                                   user.id != 0 ? delegate.findRolesByUser(user) : (user.roles != nil ? user.roles : [Role]()))
                self.roles = roles
                self.user?.roles = userRoles
                tableView.reloadData()
            } catch (let error as Exception) {
                fault(error)
            }
        }
    }
    
    func fault(_ exception: Exception) {
        let alertController = UIAlertController(title: "Error", message: exception.message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}

extension UserRole: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // number of rows
        roles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // cell content initialize - checkmark/none
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserRoleCell", for: indexPath)
        
        let role = roles?[indexPath.row]
        cell.textLabel?.text = role?.name
        
        if user?.roles?.filter({ $0.id == role?.id }).isEmpty == false {
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
            user?.roles?.append((roles?[indexPath.row])!)
            responder?(user)
        } else {
            cell!.accessoryType = UITableViewCell.AccessoryType.none
            user?.roles = user?.roles?.filter {
                $0.id as AnyObject !== roles![indexPath.row].id as AnyObject
            }
            responder?(user)
        }
        
    }
}
