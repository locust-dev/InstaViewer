//
//  NetworkSearchService.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import Foundation

class NetworkSearchService {
    
    static let shared = NetworkSearchService()
    private init() {}
    
    func fetchSearchedUsers(url: String, completion: @escaping (SearchResults?) -> Void) {
        guard let url = URL(string: url) else { return }
        NetworkService.shared.createRequest(url: url) { data in
            do {
                let searchData = try JSONDecoder().decode(SearchResultsData.self, from: data)
                guard let results = SearchResults(searchData: searchData) else {
                    completion(nil)
                    return
                }
                completion(results)
            } catch let error {
                print(error)
            }
        }
    }
    
    func fetchSearchedUserAvatar(user: SearchedUser, completion: @escaping (Data?) -> Void) {
        NetworkService.shared.fetchImage(url: user.picture ?? "") { imageData in
            guard let data = imageData else {
                completion(nil)
                return
            }
            completion(data)
        }
    }
    
    
}
