//
//  Posts.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

struct Posts {
    var posts: [Post]? = []
    let hasNextPage: Bool?
    let pageId: String?
    
    init?(postsData: PostsData) {
        posts = Post.getPost(postsData: postsData)
        hasNextPage = postsData.meta.hasNext
        pageId = postsData.meta.pageId
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
    let squarePostImage: [String]
    let video: String
    let likesCount: Int
    let ownerId: Int?
    let comments: [Comment]?
    let type: TypeOfPost
    
    static func getPost(postsData: PostsData?) -> [Post]? {
        var posts = [Post]()
        guard let data = postsData, let postsList = data.data else { return nil }
        
        for post in postsList {
            var type: TypeOfPost {
                switch post.type {
                case "sidecar": return .sidecar
                case "video": return .video
                default: return .image
                }
            }
    
            let newPost = Post(
                originalPostImage: post.images?.original?.high ?? "",
                thumbnailPostImage: post.images?.thumbnail ?? "",
                squarePostImage: post.images?.square ?? [],
                video: post.videos?.standard ?? "",
                likesCount: post.figures?.likesCount ?? 0,
                ownerId: post.ownerId,
                comments: Comment.getComments(commentsData: post.comments ?? nil),
                type: type
            )
            posts.append(newPost)
        }
        return posts
    }
    
}


struct Comment {
    let text: String
    let owner: String
    
    static func getComments(commentsData: CommentsData?) -> [Comment]? {
        var comments = [Comment]()
        guard let data = commentsData else { return nil }
        guard let list = data.list else { return nil }
        
        for comment in list {
            guard let text = comment.text, let owner = comment.owner?.username else { return comments }
            let newComment = Comment(text: text, owner: owner)
            comments.append(newComment)
        }
        return comments
    }
}

