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
    
    init(session: URLSession) {
        self.session = session
        super.init(name: RoleProxy.NAME, data: [Role]())
    }
    
    func findAll(_ completion: @escaping ([Role]?, NSException?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/roles")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error?.localizedDescription, userInfo: nil))
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "HTTP request failed.", userInfo: nil))
                return
            }
            
            do {
                if response.statusCode == 200 {
                    completion(try JSONDecoder().decode([Role].self, from: data), nil)
                } else {
                    let exception = try JSONDecoder().decode(Exception.self, from: data)
                    completion(nil, NSException(name: NSExceptionName(rawValue: exception.code ?? ""), reason: exception.message ?? "", userInfo: nil))
                }
            } catch let error {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error.localizedDescription, userInfo: nil))
            }
        }.resume()
    }
    
    func findByUserId(_ id: Int, _ completion: @escaping ([Role]?, NSException?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)/roles")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error?.localizedDescription, userInfo: nil))
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "HTTP request failed.", userInfo: nil))
                return
            }
            
            do {
                if response.statusCode == 200 {
                    completion(try JSONDecoder().decode([Role].self, from: data), nil)
                } else {
                    let exception = try JSONDecoder().decode(Exception.self, from: data)
                    completion(nil, NSException(name: NSExceptionName(rawValue: exception.code ?? ""), reason: exception.message ?? "", userInfo: nil))
                }
            } catch let error {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error.localizedDescription, userInfo: nil))
            }
        }.resume()
    }
        
    func updateByUserId(_ id: Int, roles: [Role], _ completion: @escaping ([Int]?, NSException?) -> Void) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/employees/\(id)/roles")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(roles.map{ $0.id })
        } catch let error {
            completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error.localizedDescription, userInfo: nil))
            return
        }

        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error?.localizedDescription, userInfo: nil))
                return
            }

            guard let response = response as? HTTPURLResponse, let data = data else {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: "HTTP request failed.", userInfo: nil))
                return
            }

            do {
                if response.statusCode == 200 {
                    completion(try JSONDecoder().decode([Int].self, from: data), nil)
                } else {
                    let exception = try JSONDecoder().decode(Exception.self, from: data)
                    completion(nil, NSException(name: NSExceptionName(rawValue: exception.code ?? ""), reason: exception.message ?? "", userInfo: nil))
                }
            } catch let error {
                completion(nil, NSException(name: NSExceptionName(rawValue: "Error"), reason: error.localizedDescription, userInfo: nil))
            }
        }.resume()
    }
    
}
