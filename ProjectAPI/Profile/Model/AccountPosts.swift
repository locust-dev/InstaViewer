//
//  Posts.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

struct AccountPosts {
    var posts: [AccountPost]? = []
    let hasNextPage: Bool?
    let pageId: String?
    
    init?(accountPostsData: AccountPostsData) {
        posts = AccountPost.getPost(postsData: accountPostsData)
        hasNextPage = accountPostsData.meta.hasNext
        pageId = accountPostsData.meta.pageId
    }
}

struct AccountPost {
    let originalPostImage: String
    let squarePostImage: [String]
    let likesCount: Int
    let comments: [Comment]?
    
    static func getPost(postsData: AccountPostsData?) -> [AccountPost]? {
        var posts = [AccountPost]()
        guard let data = postsData else { return nil }
        guard let postsList = data.data else { return nil }
        
        for post in postsList {
            let newPost = AccountPost(
                originalPostImage: post.images?.original?.high ?? "",
                squarePostImage: post.images?.square ?? [],
                likesCount: post.figures?.likesCount ?? 0,
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

