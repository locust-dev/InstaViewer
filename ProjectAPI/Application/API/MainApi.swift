//
//  MainApiProperties.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

class MainApi {
    
    static let headers = [
        "x-rapidapi-key": "c1447e8f15msh1dcd3f98b4509cep131395jsnf65cb2187c6f",
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
