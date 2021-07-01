//
//  MainApiProperties.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

class MainApi {
    static var username = "jakdawis"
    static var searchUserName = ""
    static var postsPageId = ""
    static var hashTagForTrends = "popular"
    static var idForStories = 0

    static let headers = [
        "x-rapidapi-key": "948c7b19c0msh7ccf2418ad28997p1ce081jsne28221ca96e3",
        "x-rapidapi-host": "instagram85.p.rapidapi.com"
    ]

    static var urlForAccountInfo: String {
        "https://instagram85.p.rapidapi.com/account/\(username)/info"
    }

    static var urlForPosts: String {
        "https://instagram85.p.rapidapi.com/account/\(username)/feed"
    }

    static var urlForSearch: String {
        "https://instagram85.p.rapidapi.com/account/search/\(searchUserName)"
    }

    static var urlForTrends: String {
        "https://instagram85.p.rapidapi.com/tag/\(hashTagForTrends)/feed"
    }

}
