//
//  API.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 26.06.2021.
//

import Foundation

let headers2 = [
    "x-rapidapi-key": "d666db4bf0msh73311564b107240p199e82jsnd95a412cc2e0",
    "x-rapidapi-host": "instagram-stories1.p.rapidapi.com"
]

var urlForStories2: String {
    "https://instagram-stories1.p.rapidapi.com/v2/user_stories?userid=\(idForStoriesGlobal)"
}
