//
//  AccountInfo.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

struct AccountData: Decodable {
    let data: Info
}

struct Info: Decodable {
    let biography: String?
    let fullName: String?
    let profileImage: ProfileAvatar?
    let userName: String?
    let id: Int?
    let figures: Figures?
    let isPrivate: Bool?
    
    enum CodingKeys: String, CodingKey {
        case figures = "figures"
        case fullName = "full_name"
        case profileImage = "profile_picture"
        case userName = "username"
        case biography = "biography"
        case id = "id"
        case isPrivate = "is_private"
    }
}

struct ProfileAvatar: Decodable {
    let hd: String?
}

struct Figures: Decodable {
    let posts: Int?
    let followers: Int?
    let followings: Int?
}
