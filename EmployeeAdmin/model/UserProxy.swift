//
//  UserProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation

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
        
    func findAll() async throws -> [User] {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await session.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw try decoder.decode(Exception.self, from: data)
        }

        return try decoder.decode([User].self, from: data)
    }
    
    func findById(_ id: Int) async throws -> User {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await session.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw try decoder.decode(Exception.self, from: data)
        }
        
        return try decoder.decode(User.self, from: data)
    }
    
    func save(_ user: User) async throws -> User {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(user)
        
        let (data, response) = try await session.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 201 else {
            throw try decoder.decode(Exception.self, from: data)
        }
        
        return try decoder.decode(User.self, from: data)
    }
    
    func update(_ user: User) async throws -> User {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(user.id)")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(user)
        
        let (data, response) = try await session.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw try decoder.decode(Exception.self, from: data)
        }
        
        return try decoder.decode(User.self, from: data)
    }
    
    func deleteById(_ id: Int) async throws {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)")!)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await session.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 204 else {
            throw try decoder.decode(Exception.self, from: data)
        }
    }

    func findAllDepartments() async throws -> [Department] {
        var request = URLRequest(url: URL(string: "http://localhost:8080/departments")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw try decoder.decode(Exception.self, from: data)
        }

        return try decoder.decode([Department].self, from: data)
    }

}
