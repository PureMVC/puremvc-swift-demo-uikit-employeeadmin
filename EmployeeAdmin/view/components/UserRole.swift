//
//  UserRole.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit
import Combine

protocol UserRoleDelegate: AnyObject {
    func findAllRoles() -> AnyPublisher<[Role], Error>
    func findRolesById(_ id: Int) -> AnyPublisher<[Role], Error>
}

protocol UserRoleListener: AnyObject {
    func update(_ roles: [Role]?)
}

class UserRole: UIViewController {
    
    var id: Int?
    
    var roles: [Role]?
        
    private var dataSource: [Role]?

    private var cancellable = Set<AnyCancellable>()
    
    weak var listener: UserRoleListener?
    
    weak var delegate: UserRoleDelegate?

    open class var NAME: String { "UserRole" }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(name: UserRole.NAME, viewComponent: self)
        
        delegate?.findAllRoles()
            .flatMap { [weak self] roles in
                self?.dataSource = roles // UI Data
                
                if let roles = self?.roles {
                    return Just(roles).setFailureType(to: Error.self).eraseToAnyPublisher()
                } else if let id = self?.id, let delegate = self?.delegate {
                    return delegate.findRolesById(id).eraseToAnyPublisher() // User Data
                } else {
                    return Just([Role]()).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error)}
            }, receiveValue: { [weak self] roles in // Bind UI and User Data
                self?.roles = roles
                self?.tableView.reloadData()
            })
            .store(in: &cancellable)
    }

    func fault(_ error: Error) {
        let alertController = UIAlertController(title: "\(type(of: error))", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    deinit {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).removeView(name: UserRole.NAME)
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
            listener?.update(roles)
        } else {
            cell!.accessoryType = UITableViewCell.AccessoryType.none
            roles = roles?.filter {
                $0.id as AnyObject !== dataSource![indexPath.row].id as AnyObject
            }
            listener?.update(roles)
        }
    }
    
}
