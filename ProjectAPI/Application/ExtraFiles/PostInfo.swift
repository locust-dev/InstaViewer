//
//  PostInfo.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

var idGlobal = "3248383724"
var accountGlobal = "turinz"
var searchUserGlobal = ""
var pageIdGlobal = ""
var hashTagForTrendGlobal = "popular"

let headers = [
    "x-rapidapi-key": "02fcc3be9bmsh09fd67bfe08aa86p133277jsna19702724b41",
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
