//
//  UserProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation
import Combine

class UserProxy: Proxy {
       
    override class var NAME: String { "UserProxy" }
    
    private var session: URLSession

    private var jsonDecoder: JSONDecoder
        
    init(session: URLSession, jsonDecoder: JSONDecoder) {
        self.session = session
        self.jsonDecoder = jsonDecoder
        super.init(name: UserProxy.NAME, data: nil)
    }

    func findAll() -> AnyPublisher<[User], Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return session.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: [User].self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
    }
    
    func findById(_ id: Int) -> AnyPublisher<User, Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return session.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: User.self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
    }
    
    func save(_ user: User) -> AnyPublisher<User, Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)

        return session.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: User.self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
    }
    
    func update(_ user: User) -> AnyPublisher<User, Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(user.id)")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)

        return session.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: User.self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
    }

    func deleteById(_ id: Int) -> AnyPublisher<Never, Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)")!)
        request.httpMethod = "DELETE"

        return session.dataTaskPublisher(for: request)
                .ignoreOutput()
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
    }

    func findAllDepartments() -> AnyPublisher<[Department], Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/departments")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return session.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: [Department].self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
    }

}
