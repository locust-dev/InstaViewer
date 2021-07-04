//
//  Account.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

struct Account {
    let username: String
    let fullname: String
    let biography: String
    let profileImage: String
    let id: Int
    let isPrivate: Bool
    let website: String
    
    let followers: Int
    var followersString: String {
        return "\(followers)"
    }
    
    let followings: Int
    var followingsString: String {
        return "\(followings)"
    }
    
    let postsCount: Int
    var postsCountString: String {
        return "\(postsCount)"
    }
    
    init?(accountData: AccountData) {
        guard let data = accountData.data,
        let username = data.userName,
        let id = data.id,
        let profileImage = data.profileImage?.hd,
        let postsCount = data.figures?.posts,
        let isPrivate = data.isPrivate else { return nil }
    
        self.id = id
        self.username = username
        self.postsCount = postsCount
        self.profileImage = profileImage
        self.isPrivate = isPrivate
        self.fullname = data.fullName ?? ""
        self.biography = data.biography ?? ""
        self.website = data.website ?? ""
        self.followers = data.figures?.followers ?? 0
        self.followings = data.figures?.followings ?? 0
    }
    
}
