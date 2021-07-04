//
//  ProfileNetworkService.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 11.06.2021.
//

import Foundation

class ProfileNetworkService {
    
    private init() {}
    
    static func fetchAccountInfo(username: String, with completion: @escaping (Result<Account, NetworkError>) -> Void) {
        let urlString = MainApi.getUrlForAccountInfo(username: username)
        guard let url = URL(string: urlString) else {
            completion(.failure(.createUrlError))
            return
        }
        NetworkService.shared.getData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let accountData = try JSONDecoder().decode(AccountData.self, from: data)
                    guard let account = Account(accountData: accountData) else {
                        completion(.failure(.createObjectError))
                        return
                    }
                    completion(.success(account))
                } catch let error {
                    completion(.failure(.jsonDecodeError))
                    print(error)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func fetchPosts(username: String, pageId: String, with completion: @escaping (Result<Posts, NetworkError>) -> Void) {
        let urlString = MainApi.getUrlForAccountPosts(username: username)
        guard let url = URL(string: urlString) else {
            completion(.failure(.createUrlError))
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "by", value: "username"),
            URLQueryItem(name: "pageId", value: pageId)
        ]
        
        guard let url = components?.url else { return }
        NetworkService.shared.getData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let postsData = try JSONDecoder().decode(PostsData.self, from: data)
                    guard let accountPosts = Posts(postsData: postsData) else {
                        completion(.failure(.createObjectError))
                        return
                    }
                    completion(.success(accountPosts))
                } catch let error {
                    completion(.failure(.jsonDecodeError))
                    print(error)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
