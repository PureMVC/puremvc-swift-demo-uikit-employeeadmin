//
//  UserFormObservable.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import Combine

protocol UserFormDelegate: AnyObject {
    func findById(_ id: Int) -> AnyPublisher<User, Error>
    func save(_ user: User, roles: [Role]?) -> AnyPublisher<User, Error>
    func update(_ user: User, roles: [Role]?) -> AnyPublisher<User, Error>
    func findAllDepartments() -> AnyPublisher<[Department], Error>
}

protocol UserFormDispatcher {
    func dismissView()
    func fault(_ exception: Error)
}

class UserFormViewModel: ObservableObject {
     
    @Published var user: User?
    
    @Published var confirm: String?
    
    @Published var departments: [Department] = [Department(id: 0, name: "--None Selected--")]
        
    private var cancellable = Set<AnyCancellable>()
    
    var dispatcher: UserFormDispatcher?
    
    weak var delegate: UserFormDelegate?
    
    open var NAME: String { "UserFormViewModel" }
    
    func initialize() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(name: NAME, viewComponent: self)
        
        guard let delegate else { return }
        
        var publishers = Publishers.Zip(delegate.findAllDepartments(),
                                        Just(User(id: 0)).setFailureType(to: Error.self).eraseToAnyPublisher())
        
        if let user, user.id != 0 { // existing user
            publishers = Publishers.Zip(delegate.findAllDepartments(), delegate.findById(user.id)) // User Data (conditional)
        }
        
        publishers // Parallelize UI and User Data requests
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] departments, user in // Bind UI and User Data
                self?.departments.append(contentsOf: departments)
                self?.user = user
                self?.confirm = user.password
            })
            .store(in: &cancellable)
    }
    
    func findById(id: Int) {
        delegate?.findById(id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] user in
                self?.user = user
                self?.confirm = user.password
            })
            .store(in: &cancellable)
    }
    
    func saveOrUpdate() {
        guard let user, let delegate else { return }
        
        let publisher = (user.id == 0) ? delegate.save(user, roles: user.roles) : delegate.update(user, roles: user.roles)
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] user in
                self?.user = user
                self?.dispatcher?.dismissView()
            })
            .store(in: &cancellable)
    }
    
    func fault(_ exception: Error) {
        dispatcher?.fault(exception)
    }
    
    deinit {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).removeView(name: NAME)
    }
    
}
