//
//  UserList.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserListDelegate: class {
    func findAll() throws -> [User]?
    func deleteById(_ id: Int64?) throws -> Int32?
}

class UserList: UIViewController {
    
    private var users: [User]?
    
    private var indexPath: IndexPath?
    
    weak var delegate: UserListDelegate?
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        (UIApplication.shared.delegate as! AppDelegate).registerView(view: self);
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
    
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = indexPath { // fade in the updated row
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        if let users = users, tableView.numberOfRows(inSection: 0) != users.count {
            tableView.insertRows(at: [IndexPath(row: users.count-1, section: 0)], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // segue to UserForm to show user details
        if let identifier = segue.identifier, identifier == "segueToUserForm" {
            if let userForm = segue.destination as? UserForm {
                if let id = sender as? Int64 { // existing vs. new user
                    userForm.id = id
                }
            }
        }
    }
    
    func fault(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
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
        self.indexPath = indexPath
        self.performSegue(withIdentifier: "segueToUserForm", sender: users![indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { // delete user from the tableView and model
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            DispatchQueue.global().async { [weak self] in
                do {
                    _ = try self?.delegate?.deleteById(self?.users?[indexPath.row].id)
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
