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

let headers = [
    "x-rapidapi-key": "a047482573msh2fe19b21b962d48p17bb9djsn2904ff2d0097",
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
