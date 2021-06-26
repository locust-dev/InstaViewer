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

struct Post {
    let originalPostImage: String
    let thumbnailPostImage: String
    let squarePostImage: [String]
    let likesCount: Int
    let ownerId: Int?
    let comments: [Comment]?
    
    static func getPost(postsData: PostsData?) -> [Post]? {
        var posts = [Post]()
        guard let data = postsData else { return nil }
        guard let postsList = data.data else { return nil }
        
        for post in postsList {
            let newPost = Post(
                originalPostImage: post.images?.original?.high ?? "",
                thumbnailPostImage: post.images?.thumbnail ?? "",
                squarePostImage: post.images?.square ?? [],
                likesCount: post.figures?.likesCount ?? 0,
                ownerId: post.ownerId,
                comments: Comment.getComments(commentsData: post.comments ?? nil)  )
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

