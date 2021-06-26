//
//  PostInfo.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

var idGlobal = "3248383724"
var accountGlobal = "tatiana__park"
var searchUserGlobal = ""
var pageIdGlobal = ""
var hashTagForTrendGlobal = "popular"
var idConverterGlobal = 0
var idForStoriesGlobal = 0

let headers = [
    "x-rapidapi-key": "f79bc03d6amsh5d44fb71431795ep197f75jsnd033a6e30329",
    "x-rapidapi-host": "instagram85.p.rapidapi.com"
]

var urlForAccountInfo: String {
    "https://instagram85.p.rapidapi.com/account/\(accountGlobal)/info"
}

var urlForPosts: String {
    "https://instagram85.p.rapidapi.com/account/\(accountGlobal)/feed"
}

var urlForSearch: String {
    "https://instagram85.p.rapidapi.com/account/search/\(searchUserGlobal)"
}

var urlForTrends: String {
    "https://instagram85.p.rapidapi.com/tag/\(hashTagForTrendGlobal)/feed"
}

var urlForIdConverter: String {
    "https://instagram85.p.rapidapi.com/convert/\(idConverterGlobal)/username"
}

var urlForStories: String {
    "https://instagram85.p.rapidapi.com/account/\(idForStoriesGlobal)/stories"
}
