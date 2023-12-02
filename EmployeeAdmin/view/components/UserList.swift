//
//  UserList.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit
import Combine

protocol UserListDelegate: AnyObject {
    func findAll() -> AnyPublisher<[User], Error>
    func deleteById(_ id: Int) -> AnyPublisher<Never, Error>
}

class UserList: UIViewController {
    
    private var users: [User]?

    private var cancellable = Set<AnyCancellable>()

    weak var delegate: UserListDelegate?

    open class var NAME: String { "UserList" }

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(name: UserList.NAME, viewComponent: self)

        delegate?.findAll()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion { self?.fault(error) }
                }, receiveValue: { [weak self] users in
                    self?.users = users
                    self?.tableView.reloadData()
                })
                .store(in: &cancellable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       if let indexPath = tableView.indexPathForSelectedRow {
           tableView.deselectRow(at: indexPath, animated: animated)
       }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "segueToUserForm", sender: User(id: 0))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToUserForm",
            let user = sender as? User,
            let userForm = segue.destination as? UserForm {
            
            userForm.user = user
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
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    deinit {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).removeView(name: UserList.NAME)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { // delete user from the tableView and model
        if editingStyle == .delete {
            guard let id = users?[indexPath.row].id else { return }
            delegate?.deleteById(id)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] (completion: Subscribers.Completion<Error>) in
                    switch completion {
                    case .finished:
                        self?.users?.remove(at: indexPath.row)
                        self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                    case .failure(let error):
                        self?.fault(error)
                    }
                    }, receiveValue: { _ in }
                )
                .store(in: &cancellable)
        }
    }
    
}
