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

class UserRole: UIViewController {
    
    var user: User?
    
    var roles: [Role]?
        
    private var cancellable = Set<AnyCancellable>()
    
    var responder: ((User?) -> Void)?
    
    weak var delegate: UserRoleDelegate?

    open class var NAME: String { "UserRole" }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        navigationItem.title = "My Title"

        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(name: UserRole.NAME, viewComponent: self)
        
        guard let delegate else { return }
        
        var publishers = Publishers.Zip(delegate.findAllRoles(), // new user, empty roles
                                        Just([Role]()).setFailureType(to: Error.self).eraseToAnyPublisher())
        if user?.id == 0 { // new user
            if let roles = user?.roles { // has roles
                publishers = Publishers.Zip(delegate.findAllRoles(),
                                                Just(roles).setFailureType(to: Error.self).eraseToAnyPublisher())
            }
        } else if let user { // existing usesr
            publishers = Publishers.Zip(delegate.findAllRoles(), delegate.findRolesById(user.id))
            if let roles = user.roles { // roles not empty
                publishers = Publishers.Zip(delegate.findAllRoles(),
                                            Just(roles).setFailureType(to: Error.self).eraseToAnyPublisher())
            }
        }
        
        publishers
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] dataSource, roles in
                self?.roles = dataSource
                self?.user?.roles = roles
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
