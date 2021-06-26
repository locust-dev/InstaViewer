//
//  PostMetadata.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 11.06.2021.
//

struct PostsData: Decodable {
    let data: [PostData]?
    let meta: Meta
}

struct PostData: Decodable {
    let ownerId: Int?
    let images: PostImage?
    let figures: PostFigures?
    let comments: CommentsData?
    
    enum CodingKeys: String, CodingKey {
        case ownerId = "owner_id"
        case images = "images"
        case figures = "figures"
        case comments = "comments"
    }
}

struct CommentsData: Decodable {
    let list: [CommentData]?
}

struct CommentData: Decodable {
    let text: String?
    let owner: CommentOwner?
}

struct CommentOwner: Decodable {
    let username: String?
}

struct PostFigures: Decodable {
    let likesCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case likesCount = "likes_count"
    }
}

struct PostImage: Decodable {
    let original: OriginalImage?
    let square: [String]?
    let thumbnail: String?
}

struct OriginalImage: Decodable {
    let high: String?
}

struct Meta: Decodable {
    let hasNext: Bool?
    let pageId: String?
    
    enum CodingKeys: String, CodingKey {
        case hasNext = "has_next"
        case pageId = "next_page"
    }
}
