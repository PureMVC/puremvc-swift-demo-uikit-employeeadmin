// data
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
        
    init(session: URLSession) {
        self.session = session
        super.init(name: UserProxy.NAME, data: nil)
    }
    
    func findAll(_ completion: @escaping ([User]?, NSException?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error?.localizedDescription, userInfo: nil))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "HTTP request failed.", userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "Did not receive data.", userInfo: nil))
                return
            }
            
            do {
                completion(try JSONDecoder().decode([User].self, from: data), nil)
            } catch let error {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error.localizedDescription, userInfo: nil))
            }
        }.resume()
    }
    
    func findById(_ id: Int, _ completion: @escaping (User?, NSException?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error?.localizedDescription, userInfo: nil))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "HTTP request failed.", userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "Did not receive data.", userInfo: nil))
                return
            }
            
            do {
                completion(try JSONDecoder().decode(User.self, from: data), nil)
            } catch let error {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error.localizedDescription, userInfo: nil))
            }
        }.resume()
    }
    
    func save(_ user: User, completion: @escaping (Int?, NSException?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error?.localizedDescription, userInfo: nil))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "HTTP request failed.", userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "Did not receive data.", userInfo: nil))
                return
            }
            
            do {
                completion(try JSONDecoder().decode(User.self, from: data).id, nil)
            } catch let error {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error.localizedDescription, userInfo: nil))
            }
        }.resume()
    }
    
    func update(_ user: User, completion: @escaping (Int?, NSException?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost/employees/\(user.id ?? 0)")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error?.localizedDescription, userInfo: nil))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "HTTP request failed.", userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "Did not receive data.", userInfo: nil))
                return
            }
            
            do {
                completion(try JSONDecoder().decode(User.self, from: data).id, nil)
            } catch let error {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error.localizedDescription, userInfo: nil))
            }
        }.resume()
    }
    
    func deleteById(_ id: Int, _ completion: @escaping (Int?, NSException?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)")!)
        request.httpMethod = "DELETE"
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error?.localizedDescription, userInfo: nil))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 204 else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "HTTP request failed.", userInfo: nil))
                return
            }
            
            completion(1, nil)
        }.resume()
    }
    
    func findAllDepartments(_ completion: @escaping ([Department]?, NSException?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/departments")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error?.localizedDescription, userInfo: nil))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "HTTP request failed.", userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "Did not receive data.", userInfo: nil))
                return
            }
            
            do {
                completion(try JSONDecoder().decode([Department].self, from: data), nil)
            } catch let error {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error.localizedDescription, userInfo: nil))
            }
        }.resume()
    }

}
