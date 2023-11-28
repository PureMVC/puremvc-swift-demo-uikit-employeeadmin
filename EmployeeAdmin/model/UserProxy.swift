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
        
    func findAll(_ completion: @escaping (Result<[User], Exception>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees")!)
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
                response.statusCode == 200 ? completion(.success(try decoder.decode([User].self, from: data))) :
                    completion(.failure(try decoder.decode(Exception.self, from: data)))
            } catch {
                completion(.failure(Exception(message: error.localizedDescription)))
            }
        }.resume()
    }
    
    func findById(_ id: Int, _ completion: @escaping (Result<User, Exception>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)")!)
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
                response.statusCode == 200 ? completion(.success((try decoder.decode(User.self, from: data)))) :
                    completion(.failure(try decoder.decode(Exception.self, from: data)))
            } catch {
                completion(.failure(Exception(message: error.localizedDescription)))
            }
        }.resume()
    }
    
    func save(_ user: User, _ completion: @escaping (Result<User, Exception>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(user)
        
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
                response.statusCode == 201 ? completion(.success((try decoder.decode(User.self, from: data)))) :
                    completion(.failure(try decoder.decode(Exception.self, from: data)))
            } catch {
                completion(.failure(Exception(message: error.localizedDescription)))
            }
        }.resume()
    }
    
    func update(_ user: User, _ completion: @escaping (Result<User, Exception>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(user.id)")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(user)
        
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
                response.statusCode == 200 ? completion(.success((try decoder.decode(User.self, from: data)))) :
                    completion(.failure(try decoder.decode(Exception.self, from: data)))
            } catch {
                completion(.failure(Exception(message: error.localizedDescription)))
            }
        }.resume()
    }
    
    func deleteById(_ id: Int, _ completion: @escaping (Result<Void, Exception>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)")!)
        request.httpMethod = "DELETE"
        
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
                response.statusCode == 204 ? completion(.success(())) :
                    completion(.failure(try decoder.decode(Exception.self, from: data)))
            } catch {
                completion(.failure(Exception(message: error.localizedDescription)))
            }
        }.resume()
    }

    func findAllDepartments(_ completion: @escaping (Result<[Department], Exception>) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/departments")!)
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
                response.statusCode == 200 ? completion(.success(try decoder.decode([Department].self, from: data))) :
                    completion(.failure(try decoder.decode(Exception.self, from: data)))
            } catch {
                completion(.failure(Exception(message: error.localizedDescription)))
            }
        }.resume()
    }

}
