//
//  Posts.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

struct AccountPosts {
    let count: Int
    var posts = [Post]()
    
    init?(accountPostsData: AccountPostsData) {
        count = accountPostsData.count ?? 0
        posts = parsePosts(postsData: accountPostsData)
    }
    
    private mutating func parsePosts(postsData: AccountPostsData) -> [Post] {
        var parsedPosts = [Post]()
        guard let edges = postsData.edges else { return [] }
        
        for edge in edges {
            guard let postImage = edge.node?.postImage else { return [] }
            let post = Post(postImage: postImage)
            parsedPosts.append(post)
        }
        return parsedPosts
    }
}

struct Post {
    let postImage: String
}
