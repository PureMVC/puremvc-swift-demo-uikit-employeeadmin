//
//  RoleProxy.swift
//  PureMVC SWIFT Demo - EmployeeAdmin
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC
import Foundation
import Combine

class RoleProxy: Proxy {
    
    override class var NAME: String { "RoleProxy" }
        
    private var session: URLSession

    private var jsonDecoder: JSONDecoder

    init(session: URLSession, jsonDecoder: JSONDecoder) {
        self.session = session
        self.jsonDecoder = jsonDecoder
        super.init(name: RoleProxy.NAME, data: [Role]())
    }
    
    func findAll() -> AnyPublisher<[Role], Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/roles")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return session.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: [Role].self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
    }
    
    func findByUserId(_ id: Int) -> AnyPublisher<[Role], Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)/roles")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return session.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: [Role].self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
    }
        
    func updateByUserId(_ id: Int, roles: [Role]) -> AnyPublisher<[Int], Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)/roles")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(roles.map{ $0.id })

        return session.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: [Int].self, decoder: jsonDecoder)
                .eraseToAnyPublisher()
    }
    
}
