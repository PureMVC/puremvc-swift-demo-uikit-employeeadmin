//
//  UserRoleObservable.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import Combine

protocol UserRoleDelegate: AnyObject {
    func findAllRoles() -> AnyPublisher<[Role], Error>
    func findRolesById(_ id: Int) -> AnyPublisher<[Role], Error>
}

protocol UserRoleDispatcher {
    func fault(_ exception: Error)
}

class UserRoleViewModel: ObservableObject {
    
    @Published var user: User?
    
    @Published var roles = [Role]()
        
    private var cancellable = Set<AnyCancellable>()
    
    var dispatcher: UserFormDispatcher?
    
    weak var delegate: UserRoleDelegate?
    
    open var NAME: String { "UserRoleObservable" }
    
    func initialize() {
        ApplicationFacade.getInstance(key: ApplicationFacade.KEY).registerView(name: NAME, viewComponent: self)
        
        guard let delegate else { return }
        
        var publishers = Publishers.Zip(delegate.findAllRoles(), // new user, empty roles
                                        Just([Role]()).setFailureType(to: Error.self).eraseToAnyPublisher())
        
        if user?.id == 0 { // new user
            if let roles = user?.roles { // has roles
                publishers = Publishers.Zip(delegate.findAllRoles(),
                                                Just(roles).setFailureType(to: Error.self).eraseToAnyPublisher())
            }
        } else if let user { // existing usesr
            publishers = Publishers.Zip(delegate.findAllRoles(), delegate.findRolesById(user.id))
            if let roles = user.roles { // roles not empty
                publishers = Publishers.Zip(delegate.findAllRoles(),
                                            Just(roles).setFailureType(to: Error.self).eraseToAnyPublisher())
            }
        }
        
        publishers
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion { self?.fault(error) }
            }, receiveValue: { [weak self] dataSource, roles in
                self?.roles.append(contentsOf: dataSource)
                self?.user?.roles = roles
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
