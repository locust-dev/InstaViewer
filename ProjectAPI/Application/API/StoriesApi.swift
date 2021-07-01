//
//  StoriesApi.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 26.06.2021.
//

class StoriesApi {
    
    static let storyHeaders = [
        "x-rapidapi-key": "1726cb85d7msh5277960294c269dp11d7c3jsn794686384758",
        "x-rapidapi-host": "instagram-stories1.p.rapidapi.com"
    ]
    
    static var urlForStories: String {
        "https://instagram-stories1.p.rapidapi.com/v2/user_stories?userid=\(MainApi.idForStories)"
    }
    
}
