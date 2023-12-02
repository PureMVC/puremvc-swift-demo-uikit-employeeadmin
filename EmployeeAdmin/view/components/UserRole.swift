//
//  UserRole.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserRoleDelegate: AnyObject {
    func findAllRoles(_ completion: @escaping (Result<[Role], Exception>) -> Void)
    func findRolesByUser(_ user: User, _ completion: @escaping (Result<[Role], Exception>) -> Void)
}

class UserRole: UIViewController {
    
    var user: User?
            
    private var roles: [Role]?
    
    var responder: ((User?) -> Void)?
        
    weak var delegate: UserRoleDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let group = DispatchGroup()
        DispatchQueue.global().async { [weak self] in // UI Data
            group.enter()
            self?.delegate?.findAllRoles{ result in
                defer { group.leave() }
                switch result {
                case .success(let roles): self?.roles = roles
                case .failure(let exception): DispatchQueue.main.async { self?.fault(exception) }
                }
            }
        }
        
        if user?.id != 0 && user?.roles == nil { // User Data (Optional)
            DispatchQueue.global().async { [weak self] in
                group.enter()
                self?.delegate?.findRolesByUser(self?.user ?? User(id: 0), { result in
                    defer { group.leave() }
                    switch result {
                    case .success(let roles):
                        self?.user?.roles = roles
                    case .failure(let exception): DispatchQueue.main.async { self?.fault(exception) }
                    }
                })
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in // Bind UI and User Data
            if self?.user?.roles == nil { self?.user?.roles = [Role]() } // User Data (Default)
            self?.tableView.reloadData()
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
