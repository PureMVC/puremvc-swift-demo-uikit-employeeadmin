//
//  UserProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2023 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation
import Combine
import PureMVC

class UserProxy: Proxy {
    
    override class var NAME: String { "UserProxy" }
    
    private var session: URLSession
    
    private var encoder: JSONEncoder
    
    private var decoder: JSONDecoder
    
    init(session: URLSession, encoder: JSONEncoder, decoder: JSONDecoder) {
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
        super.init(name: UserProxy.NAME, data: nil)
    }
    
    func findAll() -> AnyPublisher<[User], Exception> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return session.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw try self?.decoder.decode(Exception.self, from: data) ?? Exception(message: "An unknown error occurred.")
                }
                return data
            }
            .decode(type: [User].self, decoder: decoder)
            .mapError { $0 as? Exception ?? Exception(message: "A decoding error occurred.") }
            .eraseToAnyPublisher()
    }
    
    func findById(_ id: Int) -> AnyPublisher<User, Exception> {
         var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)")!)
         request.httpMethod = "GET"
         request.setValue("application/json", forHTTPHeaderField: "Accept")

         return session.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw try self?.decoder.decode(Exception.self, from: data) ?? Exception(message: "An unknown error occurred.")
                }
                return data
            }
            .decode(type: User.self, decoder: decoder)
            .mapError { $0 as? Exception ?? Exception(message: "A decoding error occurred.") }
            .eraseToAnyPublisher()
     }
    
    func save(_ user: User) -> AnyPublisher<User, Exception> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(user)

        return session.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                    throw try self?.decoder.decode(Exception.self, from: data) ?? Exception(message: "An unknown error occurred.")
                }
                return data
            }
            .decode(type: User.self, decoder: decoder)
            .mapError { $0 as? Exception ?? Exception(message: "A decoding error occurred.") }
            .eraseToAnyPublisher()
    }
    
    func update(_ user: User) -> AnyPublisher<User, Exception> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(user.id)")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(user)

        return session.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw try self?.decoder.decode(Exception.self, from: data) ?? Exception(message: "An unknown error occurred.")
                }
                return data
            }
            .decode(type: User.self, decoder: decoder)
            .mapError { $0 as? Exception ?? Exception(message: "A decoding error occurred.") }
            .eraseToAnyPublisher()
    }
    
    func deleteById(_ id: Int) -> AnyPublisher<Never, Exception> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)")!)
        request.httpMethod = "DELETE"

        return session.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let response = response as? HTTPURLResponse, response.statusCode == 204 else {
                    throw try self?.decoder.decode(Exception.self, from: data) ?? Exception(message: "An unknown error occurred.")
                }
                return data
            }
            .ignoreOutput()
            .mapError { $0 as? Exception ?? Exception(message: "A decoding error occurred.") }
            .eraseToAnyPublisher()
    }
    
    func findAllDepartments() -> AnyPublisher<[Department], Exception> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/departments")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return session.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw try self?.decoder.decode(Exception.self, from: data) ??
                        Exception(message: "An unknown error occurred.")
                }
                return data
            }
            .decode(type: [Department].self, decoder: decoder)
            .mapError { $0 as? Exception ?? Exception(message: "A decoding error occurred.") }
            .eraseToAnyPublisher()
    }
    
}
