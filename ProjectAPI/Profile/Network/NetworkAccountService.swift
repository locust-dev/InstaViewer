//
//  NetworkManager.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 11.06.2021.
//

import Foundation

class NetworkAccountService {
    
    static let shared = NetworkAccountService()
    private init() {}
    
    func fetchAccountInfo(from url: String, with completion: @escaping (Account?) -> Void) {
        guard let url = URL(string: url) else { return }
        NetworkService.shared.createRequest(url: url) { data in
            do {
                let accountData = try JSONDecoder().decode(AccountData.self, from: data)
                guard let account = Account(accountData: accountData) else {
                    completion(nil)
                    return
                }
                completion(account)
            } catch let error {
                print(error)
            }
        }
    }
    
    func fetchProfilePosts(from url: String, with completion: @escaping (Posts?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "by", value: "username"),
            URLQueryItem(name: "pageId", value: pageIdGlobal)
        ]
        
        NetworkService.shared.createRequest(url: (components?.url)!) { data in
            do {
                let postsData = try JSONDecoder().decode(PostsData.self, from: data)
                guard let accountPosts = Posts(postsData: postsData) else {
                    completion(nil)
                    return
                }
                completion(accountPosts)
            } catch let error {
                print(error)
            }
        }
    }
}
