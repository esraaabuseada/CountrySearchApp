//
//  NetworkManager.swift
//  CountrySearchApp
//
//  Created by Es on 06/03/2025.
//

import Foundation

import Alamofire

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case unknownError
}

class NetworkManager {
    
    
    static var shared: NetworkManager!
    
    private let session: Session
    
     init() {
       
        let configuration = URLSessionConfiguration.default
        session = Session(configuration: configuration)
         NetworkManager.shared = self
    }
    
    // MARK: - Generic GET Request Method
    func get<T: Decodable>(_ url: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        session.request(url, method: .get)
            .validate() // Ensures the response code is 2xx
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let decodedResponse):
                    completion(.success(decodedResponse))
                case .failure:
                    completion(.failure(.decodingFailed))
                }
            }
    }
    
    // MARK: - Generic POST Request Method
    func post<T: Decodable>(_ url: String, parameters: [String: Any], completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let decodedResponse):
                    completion(.success(decodedResponse))
                case .failure:
                    completion(.failure(.decodingFailed))
                }
            }
    }
    
    // MARK: - Handle Network Reachability (Optional)
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        session.request("https://www.google.com").validate().response { response in
            if response.error == nil {
                completion(true) // Network is reachable
            } else {
                completion(false) // No internet connection
            }
        }
    }
    
}
