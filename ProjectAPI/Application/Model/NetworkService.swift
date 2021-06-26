//
//  NetworkService.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    func createRequest(url: URL, with completion: @escaping (Data) -> Void) {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No description")
                return
            }
            completion(data)
        }.resume()
    }
    
    func fetchImage(url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        guard let imageData = try? Data(contentsOf: url) else {
            return
        }
        completion(imageData)
    }
}
