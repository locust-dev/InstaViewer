//
//  TrendsNetworkService.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 17.06.2021.
//
import Foundation

class TrendsNetworkService {
    
    private init() {}
    
    static func fetchTrendPosts(from url: String, with completion: @escaping (Posts) -> Void) {
        guard let url = URL(string: url) else { return }
        
        NetworkService.getRequest(url: url) { data in
            do {
                let postsData = try JSONDecoder().decode(PostsData.self, from: data)
                guard let trendPosts = Posts(postsData: postsData) else { return }
                completion(trendPosts)
            } catch let error {
                print(error)
            }
        }
    }
    
}
