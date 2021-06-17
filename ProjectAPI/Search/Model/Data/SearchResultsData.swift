//
//  SearchResultsData.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import Foundation

struct SearchResultsData: Decodable {
    let data: [SearchedUserData]?
}

struct SearchedUserData: Decodable {
    let id: Int?
    let fullname: String?
    let username: String?
    let picture: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fullname = "full_name"
        case username = "username"
        case picture = "picture"
    }
}
