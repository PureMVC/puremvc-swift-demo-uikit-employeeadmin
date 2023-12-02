//
//  UserList.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserListDelegate: AnyObject {
    func findAll(_ completion: @escaping (Result<[User], Error>) -> Void)
    func deleteById(_ id: Int, _ completion: @escaping (Result<Void, Error>) -> Void)
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
                case .failure(let error):
                    DispatchQueue.main.async { self?.fault(error) }
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
            userForm.responder = { [weak self] user in
                guard let user else { return }
                if let index = self?.users?.firstIndex(where: { $0.id == user.id }) { // update
                    self?.users?[index] = user
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    }
                } else { // insert
                    self?.users?.append(user)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                        self?.tableView.insertRows(at: [IndexPath(row: (self?.users?.count ?? 1) - 1, section: 0)], with: .automatic)
                    }
                }
            }
        }
    }
    
    
    func fault(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: (error as? Exception)?.message ?? error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
                    case .failure(let error):
                        DispatchQueue.main.async { self?.fault(error) }
                    }
                }
            }
        }
    }
    
}

