//
//  UserList.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserListDelegate: AnyObject {
    func findAll(_ completion: @escaping (Result<[User], Exception>) -> Void)
    func deleteById(_ id: Int, _ completion: @escaping (Result<Void, Exception>) -> Void)
}

class UserList: UIViewController {
    
    private var users: [User]?
        
    weak var delegate: UserListDelegate?
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(view: self)
        
        DispatchQueue.global().async { [weak self] in
            self?.delegate?.findAll { result in
                switch result {
                case .success(let users):
                    self?.users = users
                    DispatchQueue.main.async { self?.tableView.reloadData() }
                case .failure(let exception):
                    DispatchQueue.main.async { self?.fault(exception) }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // segue to UserForm to show user details
        if let identifier = segue.identifier, identifier == "segueToUserForm", let userForm = segue.destination as? UserForm {
            if let user = sender as? User {
                userForm.user = user
            }
            userForm.listener = self
        }
    }
    
    
    func fault(_ exception: Exception) {
        let alertController = UIAlertController(title: "Error", message: exception.message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UserList: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // number of rows
        users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // cell contents
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath as IndexPath)
        cell.textLabel?.text = users?[indexPath.row].givenName
        return cell
    }
    
}

extension UserList: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // show details of the user
        self.performSegue(withIdentifier: "segueToUserForm", sender: users![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            DispatchQueue.global().async { [weak self] in
                self?.delegate?.deleteById(self?.users?[indexPath.row].id ?? 0) { result in
                    switch result {
                    case .success():
                        self?.users?.remove(at: indexPath.row)
                        DispatchQueue.main.async { self?.tableView.deleteRows(at: [indexPath], with: .automatic) }
                    case .failure(let exception):
                        DispatchQueue.main.async { self?.fault(exception) }
                    }
                }
            }
        }
    }
    
}

extension UserList: UserFormListener {
    
    func save(_ user: User) {
        users?.append(user)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.tableView.insertRows(at: [IndexPath(row: (self?.users?.count ?? 1) - 1, section: 0)], with: .automatic)
        }
    }
    
    func update(_ user: User) {
        if let index = users?.firstIndex(where: { $0.id == user.id }) {
            self.users?[index] = user
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
        }
    }
    
}

