//
//  SearchedUsers.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import Foundation

struct SearchResults {
    let results: [SearchedUser]
    
    init(searchData: SearchResultsData) {
        var results = [SearchedUser]()
        for user in searchData.data {
            guard let user = SearchedUser(searchedUserData: user) else { continue }
            results.append(user)
        }
        
        self.results = results
    }
}

struct SearchedUser {
    let id: Int
    let extraInfo: String
    let username: String
    let picture: String?
    
    init?(searchedUserData: SearchedUserData) {
        guard let id = searchedUserData.id,
        let username = searchedUserData.username,
        let picture = searchedUserData.picture else { return nil }
        
        self.id = id
        self.username = username
        self.picture = picture
        self.extraInfo = searchedUserData.fullname ?? ""
    }
}
