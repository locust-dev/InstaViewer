//
//  StoriesData.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 24.06.2021.
//

struct StoriesData: Decodable {
    let profilePic: String?
    let downloadLinks: [StoryData]?
    let totalStories: Int?
}

struct StoryData: Decodable {
    let thumbnail: String?
    let mediaType: String?
    let url: String?
}
