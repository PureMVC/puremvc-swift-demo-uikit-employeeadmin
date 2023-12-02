//
//  UserList.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserListDelegate: AnyObject {
    func findAll() async throws -> [User]
    func deleteById(_ id: Int) async throws
}

class UserList: UIViewController {
    
    private var users: [User]?
        
    weak var delegate: UserListDelegate?
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(view: self)
        
        Task {
            do {
                users = try await delegate?.findAll()
                tableView.reloadData()
            } catch(let error) {
                fault(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    @IBAction func add() {
        performSegue(withIdentifier: "segueToUserForm", sender: User(id: 0))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // segue to UserForm to show user details
        if let identifier = segue.identifier, identifier == "segueToUserForm", let destination = segue.destination as? UserForm {
            if let user = sender as? User {
                destination.user = user
            }
            destination.responder = { [weak self] user in
                guard let user else { return }
                if let index = self?.users?.firstIndex(where: { $0.id == user.id }) { // update
                    self?.users?[index] = user
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    }
                } else { // insert
                    self?.users?.append(user)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        self?.tableView.insertRows(at: [IndexPath(row: (self?.users?.count ?? 1) - 1, section: 0)], with: .fade)
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
            Task {
                do {
                    try await delegate?.deleteById(users?[indexPath.row].id ?? 0)
                    users?.remove(at: indexPath.row)
                    DispatchQueue.main.async { [weak self] in self?.tableView.deleteRows(at: [indexPath], with: .automatic) }
                } catch(let error) {
                    fault(error)
                }
            }
        }
    }
    
}

