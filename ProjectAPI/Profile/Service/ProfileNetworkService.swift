//
//  ProfileNetworkService.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 11.06.2021.
//

import Foundation

class ProfileNetworkService {
    
    private init() {}
    
    static func fetchAccountInfo(username: String, with completion: @escaping (Account) -> Void) {
        guard let url = URL(string: MainApi.getUrlForAccountInfo(username: username)) else { return }
        NetworkService.shared.getRequest(url: url) { data in
            do {
                let accountData = try JSONDecoder().decode(AccountData.self, from: data)
                guard let account = Account(accountData: accountData) else {
                    return
                }
                completion(account)
            } catch let error {
                print(error)
            }
        }
    }
    
    static func fetchProfilePosts(username: String, pageId: String, with completion: @escaping (Posts) -> Void) {
        guard let url = URL(string: MainApi.getUrlForAccountPosts(username: username)) else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "by", value: "username"),
            URLQueryItem(name: "pageId", value: pageId)
        ]
        
        NetworkService.shared.getRequest(url: (components?.url)!) { data in
            do {
                let postsData = try JSONDecoder().decode(PostsData.self, from: data)
                guard let accountPosts = Posts(postsData: postsData) else { return }
                completion(accountPosts)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}
