//
//  MainApiProperties.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

class MainApi {
    
    static let headers = [
        "x-rapidapi-key": "709ab3138amsh3525c0b23c2b947p1536e9jsnad70bd5723e4",
        "x-rapidapi-host": "instagram85.p.rapidapi.com"
    ]

    static func getUrlForAccountInfo(username: String) -> String {
        "https://instagram85.p.rapidapi.com/account/\(username)/info"
    }
    
    static func getUrlForAccountPosts(username: String) -> String {
        "https://instagram85.p.rapidapi.com/account/\(username)/feed"
    }
    
    static func getUrlForTrends(hashtag: String) -> String {
        "https://instagram85.p.rapidapi.com/tag/\(hashtag)/feed"
    }
    
    static func getUrlForSearch(username: String) -> String {
        "https://instagram85.p.rapidapi.com/account/search/\(username)"
    }

}
