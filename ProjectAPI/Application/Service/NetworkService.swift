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
    
    func getData(url: URL, with completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = MainApi.headers
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let _ = error {
                completion(.failure(.createRequestError))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.emptyDataFromRequest))
            }
        }.resume()
    }
    
    func fetchImage(urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.createUrlError))
            return }
        guard let imageData = try? Data(contentsOf: url) else {
            completion(.failure(.createImageFromDataError))
            return }
        guard let image = UIImage(data: imageData) else {
            completion(.failure(.createImageFromDataError))
            return
        }
        completion(.success(image))
    }
    
}
