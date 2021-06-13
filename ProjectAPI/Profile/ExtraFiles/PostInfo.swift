//
//  PostInfo.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

var idGlobal = "3248383724"
var postsCountGlobal = 10
var accountGlobal = "turinz"

let headers = [
    "x-rapidapi-key": "02fcc3be9bmsh09fd67bfe08aa86p133277jsna19702724b41",
    "x-rapidapi-host": "instagram40.p.rapidapi.com"
]

var urlForPosts: String { "https://instagram40.p.rapidapi.com/account-medias?userid=\(idGlobal)&first=\(postsCountGlobal)&after=QVFDOGV6dGFtQnJXdnZ0a1FuMkFLSjRHYjdWMEdTTFltMkZpd1FvcUxuQXZ6bDJFVnpKRzFYU3RMSUoyNXluOXFZUVZ3dG1YM3NSTEJqMVI3TTBKM0ZTNg%3D%3D"
}

var urlForAccountInfo: String { "https://instagram40.p.rapidapi.com/account-info?username=\(accountGlobal)"
}
