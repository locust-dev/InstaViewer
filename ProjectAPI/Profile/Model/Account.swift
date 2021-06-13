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
    let id: String
    
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
        fullName = accountData.fullName ?? "Unknown"
        userName = accountData.userName ?? "Unknown"
        biography = accountData.biography ?? "Unknown"
        profileImage = accountData.profileImage ?? "Unknown"
        followed = accountData.followed?.count ?? 0
        follow = accountData.follow?.count ?? 0
        postsCount = accountData.postsCount?.count ?? 0
        id = accountData.id ?? "Unknown"
    }
}
