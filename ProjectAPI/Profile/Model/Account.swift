//
//  Account.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

struct Account {
    let fullName: String
    let userName: String
    let biography: String
    let profileImage: String
    let id: Int
    let isPrivate: Bool
    
    let followed: Int
    var followedString: String {
        return "\(followed)"
    }
    
    let follow: Int
    var followString: String {
        return "\(follow)"
    }
    
    let postsCount: Int
    var postsCountString: String {
        return "\(postsCount)"
    }
    
    init?(accountData: AccountData) {
        fullName = accountData.data.fullName ?? "Null"
        userName = accountData.data.userName ?? "Null"
        biography = accountData.data.biography ?? "Null"
        profileImage = accountData.data.profileImage?.hd ?? "Null"
        followed = accountData.data.figures?.followers ?? 0
        follow = accountData.data.figures?.followings ?? 0
        postsCount = accountData.data.figures?.posts ?? 0
        id = accountData.data.id ?? 0
        isPrivate = accountData.data.isPrivate ?? true
    }
}
