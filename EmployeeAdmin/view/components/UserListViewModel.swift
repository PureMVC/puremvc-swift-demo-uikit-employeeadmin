//
//  UserListObserver.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import Combine

protocol UserListDelegate: AnyObject {
    func findAll() -> AnyPublisher<[User], Exception>
    func deleteById(_ id: Int) -> AnyPublisher<Never, Exception>
}

protocol UserListDispatcher {
    func fault(_ exception: Exception)
}

class UserListViewModel: ObservableObject {
        
    @Published var users: [User] = []
    
    private var cancellable = Set<AnyCancellable>()

    weak var delegate: UserListDelegate?
    
    var dispatcher: UserListDispatcher?
    
    open var NAME: String { "UserListObservable" }
    
    func initialize() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(name: NAME, viewComponent: self)
        
        delegate?.findAll()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] users in
                self?.users = users
            })
            .store(in: &cancellable)
    }
    
    func deleteByIndex(_ index: Int) {
        delegate?.deleteById(users[index].id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] (completion: Subscribers.Completion<Exception>) in
                switch completion {
                case .finished:
                    self?.users.remove(at: index)
                case .failure(let error):
                    self?.fault(error)
                }
                }, receiveValue: { _ in }
            )
            .store(in: &cancellable)
    }
    
    func fault(_ exception: Exception) {
        dispatcher?.fault(exception)
    }
    
    deinit {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).removeView(name: NAME)
    }
    
}
