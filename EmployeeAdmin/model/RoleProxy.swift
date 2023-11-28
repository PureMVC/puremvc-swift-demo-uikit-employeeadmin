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
    
    func findAll(_ completion: @escaping (Result<[Role], Exception>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/roles")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                return completion(.failure(Exception(message: error!.localizedDescription)))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(Exception(message: "HTTP request failed.")))
            }
            
            guard let data, let decoder = self?.decoder else {
                return completion(.failure(Exception(message: "The data is invalid.")))
            }
            
            do {
                response.statusCode == 200 ? completion(.success(try decoder.decode([Role].self, from: data))) :
                    completion(.failure(try decoder.decode(Exception.self, from: data)))
            } catch {
                completion(.failure(Exception(message: error.localizedDescription)))
            }
        }.resume()
    }
    
    func findByUser(_ user: User, _ completion: @escaping (Result<[Role], Exception>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(user.id)/roles")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                return completion(.failure(Exception(message: error!.localizedDescription)))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(Exception(message: "HTTP request failed.")))
            }
            
            guard let data, let decoder = self?.decoder else {
                return completion(.failure(Exception(message: "The data is invalid.")))
            }
            
            do {
                response.statusCode == 200 ? completion(.success(try decoder.decode([Role].self, from: data))) :
                    completion(.failure(try decoder.decode(Exception.self, from: data)))
            } catch {
                completion(.failure(Exception(message: error.localizedDescription)))
            }
        }.resume()
    }
        
    func updateByUser(_ user: User, roles: [Role], _ completion: @escaping (Result<[Int], Exception>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(user.id)/roles")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(roles.map{ $0.id })

        session.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                return completion(.failure(Exception(message: error!.localizedDescription)))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(Exception(message: "HTTP request failed.")))
            }
            
            guard let data, let decoder = self?.decoder else {
                return completion(.failure(Exception(message: "The data is invalid.")))
            }
            
            do {
                response.statusCode == 200 ? completion(.success(try decoder.decode([Int].self, from: data))) :
                    completion(.failure(try decoder.decode(Exception.self, from: data)))
            } catch {
                completion(.failure(Exception(message: error.localizedDescription)))
            }
        }.resume()
    }
    
}
