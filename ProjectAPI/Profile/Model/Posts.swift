//
//  Posts.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

struct Posts {
    let posts: [Post]
    let hasNextPage: Bool
    let pageId: String
    
    init?(postsData: PostsData) {
        guard let next = postsData.meta?.hasNext,
        let page = postsData.meta?.pageId else { return nil }
        
        var loadedPosts = [Post]()
        for postData in postsData.data {
            guard let post = Post(postData: postData) else { continue }
            loadedPosts.append(post)
        }
        
        posts = loadedPosts
        hasNextPage = next
        pageId = page
    }
}

enum TypeOfPost {
    case video
    case image
    case sidecar
}

struct Post {
    let originalPostImage: String
    let thumbnailPostImage: String
    let squarePostImage: String
    let video: String
    let likesCount: Int
    let type: TypeOfPost
    
    
    init?(postData: PostData) {
        guard let original = postData.images?.original?.high,
        let square = postData.images?.square.first,
        let likes = postData.figures?.likesCount,
        let postType = postData.type else { return nil}
        
        switch postType {
        case "sidecar": type = .sidecar
        case "video": type = .video
        default: type = .image
        }
        
        originalPostImage = original
        squarePostImage = square
        likesCount = likes
        thumbnailPostImage = postData.images?.thumbnail ?? ""
        video = postData.videos?.standard ?? ""
    }
    
}
