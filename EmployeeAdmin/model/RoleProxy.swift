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

    private var encoder: JSONEncoder
    
    private var decoder: JSONDecoder

    init(session: URLSession, encoder: JSONEncoder, decoder: JSONDecoder) {
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
        super.init(name: RoleProxy.NAME, data: [Role]())
    }
    
    func findAll() -> AnyPublisher<[Role], Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/roles")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return session.dataTaskPublisher(for: request)
            .tryMap { [decoder] data, response in
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                   throw try decoder.decode(Exception.self, from: data)
                }
                return data
            }
            .decode(type: [Role].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func findByUserId(_ id: Int) -> AnyPublisher<[Role], Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)/roles")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return session.dataTaskPublisher(for: request)
            .tryMap { [decoder] data, response in
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                   throw try decoder.decode(Exception.self, from: data)
                }
                return data
            }
            .decode(type: [Role].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
        
    func updateByUserId(_ id: Int, roles: [Role]) -> AnyPublisher<[Int], Error> {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)/roles")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(roles.map{ $0.id })

        return session.dataTaskPublisher(for: request)
            .tryMap { [decoder] data, response in
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                   throw try decoder.decode(Exception.self, from: data)
                }
                return data
            }
            .decode(type: [Int].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}
