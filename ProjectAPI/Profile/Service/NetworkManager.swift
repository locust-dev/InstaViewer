//
//  NetworkManager.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 11.06.2021.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    func fetchProfilePosts(from url: String, with completion: @escaping (AccountPosts?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "No description")
                return
            }
            
            do {
                let postsData = try JSONDecoder().decode(AccountPostsData.self, from: data)
                guard let accountPosts = AccountPosts(accountPostsData: postsData) else {
                    completion(nil)
                    return
                }
                completion(accountPosts)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func fetchAccountInfo(from url: String, with completion: @escaping (Account?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "No description")
                return
            }
            
            do {
                let accountData = try JSONDecoder().decode(AccountData.self, from: data)
                guard let account = Account(accountData: accountData) else {
                    completion(nil)
                    return
                }
                completion(account)
            } catch let error {
                print("ошибка декодирования")
                print(error)
            }
        }.resume()
    }
    
}
