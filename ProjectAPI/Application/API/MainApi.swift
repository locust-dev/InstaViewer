//
//  MainApiProperties.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

class MainApi {
    
    static let headers = [
        "x-rapidapi-key": "88b281fa34mshc7aec72cfc767dfp183599jsn6daf4f3f849e",
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
