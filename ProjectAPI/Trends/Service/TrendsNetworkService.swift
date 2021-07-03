//
//  TrendsNetworkService.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 17.06.2021.
//
import Foundation

class TrendsNetworkService {
    
    private init() {}
    
    static func fetchTrendPosts(hashtag: String, with completion: @escaping (Result<Posts, NetworkErrors>) -> Void) {
        guard let url = URL(string: MainApi.getUrlForTrends(hashtag: hashtag)) else {
            completion(.failure(.createUrlError))
            return
        }
        
        NetworkService.shared.getData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let postsData = try JSONDecoder().decode(PostsData.self, from: data)
                    guard let trendPosts = Posts(postsData: postsData) else {
                        completion(.failure(.createObjectError))
                        return
                    }
                    completion(.success(trendPosts))
                } catch let error {
                    print(error)
                    completion(.failure(.jsonDecodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
