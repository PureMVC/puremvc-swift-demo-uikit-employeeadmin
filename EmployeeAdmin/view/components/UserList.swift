//
//  UserList.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserListDelegate: AnyObject {
    func findAll() throws -> [User]?
    func delete(_ user: User?) throws
}

class UserList: UIViewController {
    
    private var users: [User]?

    weak var delegate: UserListDelegate?
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global().async { [weak self] in
            do {
                self?.users = try self?.delegate?.findAll()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch let error as NSError {
                DispatchQueue.main.async { self?.fault("\(error.localizedDescription), \(error.domain), \(error.code)") }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // segue to UserForm to show user details
        if let identifier = segue.identifier, identifier == "segueToUserForm" {
            if let userForm = segue.destination as? UserForm {
                if let user = sender as? User {
                    userForm.user = user
                }
            }
        }
    }
    
    func fault(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
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
        performSegue(withIdentifier: "segueToUserForm", sender: users?[indexPath.row])
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { // delete from tableView and model
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            DispatchQueue.global().async { [weak self] in
                do {
                    try self?.delegate?.delete(self?.users?[indexPath.row])
                    self?.users?.remove(at: indexPath.row)

                    DispatchQueue.main.async {
                        self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                } catch let error as NSError {
                    DispatchQueue.main.async { self?.fault("\(error.localizedDescription), \(error.domain), \(error.code)") }
                }
            }
            
        }
    }
    
}
