//
//  SearchedUsers.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import Foundation

struct SearchResults {
    let results: [SearchedUser]
    
    init?(searchData: SearchResultsData) {
        results = SearchedUser.getSearchedUsers(searchData: searchData)
    }
}

struct SearchedUser {
    let id: Int
    let fullname: String
    let username: String
    let picture: String?
    
    static func getSearchedUsers(searchData: SearchResultsData) -> [SearchedUser] {
        var users = [SearchedUser]()
        guard let usersData = searchData.data else { return users }
        
        for user in usersData {
            guard let username = user.username else { continue }
            let newUser = SearchedUser(
                id: user.id ?? 0,
                fullname: user.fullname ?? "Unknown",
                username: username,
                picture: user.picture ?? nil)
            users.append(newUser)
        }
        return users
    }
}
