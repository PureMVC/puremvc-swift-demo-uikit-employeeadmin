//
//  UserList.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserListDelegate: class {
    func users() -> [UserVO]
    func delete(_ userVO: UserVO)
}

class UserList: UITableViewController {
    
    var userVOs: [UserVO]?
    
    var indexPath: IndexPath?
    
    weak var delegate: UserListDelegate?

    override func viewDidLoad() {
        (UIApplication.shared.delegate as! AppDelegate).registerView(view: self);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userVOs = delegate?.users()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = indexPath { // fade in the updated row
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        if let users = userVOs, tableView.numberOfRows(inSection: 0) != users.count {
            tableView.insertRows(at: [IndexPath(row: users.count-1, section: 0)], with: .automatic)
        }
    }
    
    // segue to UserForm to show user details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "segueToUserForm" {
            if let userForm = segue.destination as? UserForm {
                if let userVO = sender as? UserVO { // existing vs. new user
                    userForm.userVO = userVO
                }
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    // show details of the user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath
        self.performSegue(withIdentifier: "segueToUserForm", sender: userVOs![indexPath.row])
    }
    
    // delete user from the tableView and model
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            delegate?.delete(userVOs![indexPath.row])
            userVOs?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userVOs?.count ?? 0
    }
    
    // cell contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath as IndexPath)
        cell.textLabel?.text = userVOs?[indexPath.row].givenName
        return cell
    }

}
