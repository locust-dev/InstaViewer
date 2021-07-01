//
//  StoriesApi.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 26.06.2021.
//

class StoriesApi {
    
    static let storyHeaders = [
        "x-rapidapi-key": "c1447e8f15msh1dcd3f98b4509cep131395jsnf65cb2187c6f",
        "x-rapidapi-host": "instagram-stories1.p.rapidapi.com"
    ]
    
    static func getUrlForStories(id: Int) -> String {
        "https://instagram-stories1.p.rapidapi.com/v2/user_stories?userid=\(id)"
    }
    
}
