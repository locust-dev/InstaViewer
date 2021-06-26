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

//struct StoriesData: Decodable {
//    let data: [[StoryData]]?
//}
//
//struct StoryData: Decodable {
//    let createdTime: CreatedTime?
//    let images: Images?
//    let videos: Videos?
//
//    enum CodingKeys: String, CodingKey {
//        case createdTime = "created_time"
//        case images = "images"
//        case videos = "videos"
//    }
//}
//
//struct CreatedTime: Decodable {
//    let humanized: String?
//}
//
//struct Images: Decodable {
//    let thumbnail: String?
//    let original: ImagesResolution?
//}
//
//struct ImagesResolution: Decodable {
//    let high: String?
//}
//
//struct Videos: Decodable {
//    let standard: String?
//}
