//
//  StoriesNetworkService.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 25.06.2021.
//

import Foundation

class StoriesNetworkService {
    
    private init() {}

    static func fetchStories(_ urlString: String, id: Int, with completion: @escaping (Result<Stories, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.createUrlError))
            return
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = StoriesApi.storyHeaders
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let _ = error {
                completion(.failure(.createRequestError))
                return
            }
            
            if let data = data {
                
                do {
                    let storiesData = try JSONDecoder().decode(StoriesData.self, from: data)
                    guard let stories = Stories(storiesData: storiesData) else {
                        completion(.failure(.nullStories))
                        return
                    }
                    completion(.success(stories))
                } catch let error {
                    completion(.failure(.jsonDecodeError))
                    print(error)
                }
            } else {
                completion(.failure(.emptyDataFromRequest))
            }
        }.resume()
        
    }
    
}
