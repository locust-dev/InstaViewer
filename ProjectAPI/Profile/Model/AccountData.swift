//
//  AccountInfo.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

struct AccountData: Decodable {
    let biography: String?
    let followed: Counter?
    let follow: Counter?
    let fullName: String?
    let profileImage: String?
    let userName: String?
    let postsCount: Counter?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case followed = "edge_followed_by"
        case follow = "edge_follow"
        case fullName = "full_name"
        case profileImage = "profile_pic_url_hd"
        case postsCount = "edge_owner_to_timeline_media"
        case userName = "username"
        case biography = "biography"
        case id = "id"
    }
}

struct Counter: Decodable {
    let count: Int?
}
