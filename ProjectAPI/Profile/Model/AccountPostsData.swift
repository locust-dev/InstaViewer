//
//  PostMetadata.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 11.06.2021.
//

struct AccountPostsData: Decodable {
    let count: Int?
    let edges: [Edge]?
}

struct Edge: Decodable {
    let node: Node?
}

struct Node: Decodable {
    let postImage: String?
    
    enum CodingKeys: String, CodingKey {
        case postImage = "display_url"
    }
}
