//
//  SearchNetworkService.swift.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import Foundation

class SearchNetworkService {
    
    private init() {}
    
    static func fetchSearchedUsers(username: String, completion: @escaping (Result<SearchResults, NetworkError>) -> Void) {
        guard let url = URL(string: MainApi.getUrlForSearch(username: username)) else {
            completion(.failure(.createUrlError))
            return
        }
        NetworkService.shared.getData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let searchData = try JSONDecoder().decode(SearchResultsData.self, from: data)
                    guard let results = SearchResults(searchData: searchData) else {
                        completion(.failure(.createObjectError))
                        return
                    }
                    completion(.success(results))
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
