//
//  NetworkService.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    func getRequest(url: URL, with completion: @escaping (Data) -> Void) {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            completion(data)
        }.resume()
    }   
    
    func fetchImage(urlString: String, completion: @escaping (Result<UIImage, ErrorHangler>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlCreateError))
            return }
        guard let imageData = try? Data(contentsOf: url) else {
            completion(.failure(.createDataError))
            return }
        guard let image = UIImage(data: imageData) else {
            completion(.failure(.downloadImageError))
            return
        }
        completion(.success(image))
    }
    
}
