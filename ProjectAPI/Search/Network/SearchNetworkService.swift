//
//  SearchNetworkService.swift.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import Foundation

class SearchNetworkService {
    
    static let shared = SearchNetworkService()
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
    
    
    
    
}
