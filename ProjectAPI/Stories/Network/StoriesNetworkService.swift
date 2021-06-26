//
//  StoriesNetworkService.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 25.06.2021.
//

import Foundation

class StoriesNetworkService {
    private init() {}
    static let shared = StoriesNetworkService()
    
    func createStoriesRequest(url: URL, with completion: @escaping (Data) -> Void) {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers2
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No description")
                return
            }
            completion(data)
        }.resume()
    }
    
    func fetchStories(from url: String, with completion: @escaping ([Story]) -> Void) {
        guard let url = URL(string: url) else { return }
        
        createStoriesRequest(url: url) { data in
            do {
                let storiesData = try JSONDecoder().decode(StoriesData.self, from: data)
                guard let stories = Stories(storiesData: storiesData) else {
                    return
                }
                completion(stories.stories)
            } catch let error {
                print(error)
            }
        }
    }
}
