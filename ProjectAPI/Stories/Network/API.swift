//
//  API.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 26.06.2021.
//

import Foundation

let headers2 = [
    "x-rapidapi-key": "a047482573msh2fe19b21b962d48p17bb9djsn2904ff2d0097",
    "x-rapidapi-host": "instagram-stories1.p.rapidapi.com"
]

var urlForStories2: String {
    "https://instagram-stories1.p.rapidapi.com/v2/user_stories?userid=\(idForStoriesGlobal)"
}
