//
//  MainApiProperties.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

class MainApi {
    static var idGlobal = "3248383724"
    static var accountGlobal = "jakdawis"
    static var searchUserGlobal = ""
    static var pageIdGlobal = ""
    static var hashTagForTrendGlobal = "popular"
    static var idConverterGlobal = 0
    static var idForStoriesGlobal = 0

    static let headers = [
        "x-rapidapi-key": "d9b2b7cb4dmsh880004031408bffp17ea4bjsn3c1c3cab6c71",
        "x-rapidapi-host": "instagram85.p.rapidapi.com"
    ]

    static var urlForAccountInfo: String {
        "https://instagram85.p.rapidapi.com/account/\(accountGlobal)/info"
    }

    static var urlForPosts: String {
        "https://instagram85.p.rapidapi.com/account/\(accountGlobal)/feed"
    }

    static var urlForSearch: String {
        "https://instagram85.p.rapidapi.com/account/search/\(searchUserGlobal)"
    }

    static var urlForTrends: String {
        "https://instagram85.p.rapidapi.com/tag/\(hashTagForTrendGlobal)/feed"
    }

    static var urlForIdConverter: String {
        "https://instagram85.p.rapidapi.com/convert/\(idConverterGlobal)/username"
    }
    
}
