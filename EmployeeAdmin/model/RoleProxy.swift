//
//  RoleProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation

class RoleProxy: Proxy {
    
    override class var NAME: String { "RoleProxy" }
        
    private var session: URLSession
    
    private var encoder: JSONEncoder
    
    private var decoder: JSONDecoder
    
    init(session: URLSession, encoder: JSONEncoder, decoder: JSONDecoder) {
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
        super.init(name: RoleProxy.NAME, data: nil)
    }
    
    func findAll() async throws -> [Role] {
        var request = URLRequest(url: URL(string: "http://localhost:8080/roles")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await session.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw try decoder.decode(Exception.self, from: data)
        }
        
        return try decoder.decode([Role].self, from: data)
    }
    
    func findByUser(_ user: User) async throws -> [Role] {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(user.id)/roles")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await session.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw try decoder.decode(Exception.self, from: data)
        }
        
        return try decoder.decode([Role].self, from: data)
    }
        
    func updateByUser(_ user: User, roles: [Role]) async throws -> [Int] {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(user.id)/roles")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(roles.map{ $0.id })

        let (data, response) = try await session.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw try decoder.decode(Exception.self, from: data)
        }
        
        return try decoder.decode([Int].self, from: data)
    }
    
}
