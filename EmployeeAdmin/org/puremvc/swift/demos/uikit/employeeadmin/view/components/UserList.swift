//
//  UserList.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit

protocol UserListDelegate: class {
    func add(_ userVO: UserVO, roleVO: RoleVO)
    func update(_ userVO: UserVO, roleVO: RoleVO)
    func delete(_ userVO: UserVO)
    func getUserRoles(_ username: String) -> [RoleEnum]
}

class UserList: UITableViewController, UserFormDelegate {

    weak var delegate: UserListDelegate?
    
    var userVOs: [UserVO]?

    override func viewDidLoad() {
        (UIApplication.shared.delegate as! AppDelegate).registerView(view: self);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let users = userVOs, tableView.numberOfRows(inSection: 0) != users.count {
            tableView.insertRows(at: [IndexPath(row: users.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
        }
    }
    
    // show details of the user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToUserForm", sender: userVOs![indexPath.row])
    }
    
    // segue to UserForm to show user details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "segueToUserForm" {
            if let userForm = segue.destination as? UserForm {
                userForm.delegate = self
                if let userVO = sender as? UserVO { // existing user
                    userForm.userVO = userVO
                    userForm.roleVO = RoleVO(username: userVO.username, roles: (delegate?.getUserRoles(userVO.username)))
                } 
            }
        }
    }
    
    // add user and roles
    func add(_ userVO: UserVO, roleVO: RoleVO) {
        delegate?.add(userVO, roleVO: roleVO)
        userVOs?.append(userVO) // viewDidAppear
    }
    
    // update user and roles
    func update(_ userVO: UserVO, roleVO: RoleVO) {
        delegate?.update(userVO, roleVO: roleVO)
        for (index, element) in (userVOs!).enumerated() {
            if userVO.username == element.username {
                userVOs![index] = userVO
                let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
                cell?.textLabel?.text = userVO.givenName
                break
            }
        }
    }
    
    // number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userVOs?.count ?? 0
    }
    
    // cell contents for UserList
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath as IndexPath)
        cell.textLabel?.text = userVOs?[indexPath.row].givenName
        return cell
    }
    
    // delete user from the tableView and model
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            delegate?.delete(userVOs![indexPath.row])
            userVOs?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }

}
