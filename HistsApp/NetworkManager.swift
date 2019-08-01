//
//  NetworkManager.swift
//  HistsApp
//
//  Created by Arkadiy Grigoryanc on 31.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private init() {}
    
    static let manager = NetworkManager()
    
    private let token = "your_token"
    private let login = "your_login"
    private let session = URLSession.shared
    
    enum URLStrings {
        private static let baseURL = "https://api.github.com/"
        fileprivate static var users: String { return baseURL + "users" }
        fileprivate static var gists: String { return baseURL + "gists" }
    }
    
    enum NetworkError: Error {
        case error(message: String)
    }
    
    private func addToken(to request: inout URLRequest) {
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    }
    
    // MARK: - GET Requests
    func fetchGists(type: GistType, completion: @escaping (Result<Gists, NetworkError>) -> Void) {
        
        let url = URL(string: URLStrings.users)!.appendingPathComponent(login).appendingPathComponent("gists")
        var request = URLRequest(url: url)
        
        if type == .public {
            addToken(to: &request)
        }
        
        session.dataTask(with: request) { data, response, error in
                    
            guard error == nil else {
                completion(.failure(.error(message: error!.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.error(message: "No data")))
                return
            }
            do {
                let gists = try JSONDecoder().decode(Gists.self, from: data)
                completion(.success(gists))
            } catch {
                completion(.failure(.error(message: error.localizedDescription)))
            }
            
        }.resume()
    }
    
    func fetchImage(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        addToken(to: &request)
        
        session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.error(message: error!.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.error(message: "No data")))
                return
            }
            
            completion(.success(data))
            
        }.resume()
        
    }
    
    // MARK: - POST Requests
    func createGist(_ gist: GistPost, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        
        do {
            let url = URL(string: URLStrings.gists)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            addToken(to: &request)
            request.httpBody = try JSONEncoder().encode(gist)
            
            print(gist)
            
            session.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    completion(.failure(.error(message: error!.localizedDescription)))
                    return
                }
                
                guard let code = (response as? HTTPURLResponse)?.statusCode, code == 201 else {
                    completion(.failure(.error(message: "Code error")))
                    return
                }
                
                completion(.success(()))
                
            }.resume()
            
        } catch {
            completion(.failure(.error(message: error.localizedDescription)))
        }
        
        
    }
    
}
