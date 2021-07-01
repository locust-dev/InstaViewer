//
//  SearchNetworkService.swift.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import Foundation

class SearchNetworkService {
    
    private init() {}
    
    static func fetchSearchedUsers(username: String, completion: @escaping (SearchResults?) -> Void) {
        guard let url = URL(string: MainApi.getUrlForSearch(username: username)) else {
            completion(nil)
            return
        }
        NetworkService.shared.getRequest(url: url) { data in
            do {
                let searchData = try JSONDecoder().decode(SearchResultsData.self, from: data)
                guard let results = SearchResults(searchData: searchData) else { return }
                completion(results)
            } catch let error {
                print(error)
            }
        }
    }
    
    
}
