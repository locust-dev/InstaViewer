//
//  Stories.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 24.06.2021.
//


struct Stories {
    let profilePic: String
    let totalStories: Int
    let stories: [Story]
    
    init?(storiesData: StoriesData) {
        self.profilePic = storiesData.profilePic ?? ""
        self.totalStories = storiesData.totalStories ?? 0
        self.stories = Story.getStories(storiesData: storiesData)
    }
}

struct Story {
    let thumbnail: String
    let mediaType: String
    let url: String
    
    static func getStories(storiesData: StoriesData) -> [Story] {
        var newStories = [Story]()
        guard let stories = storiesData.downloadLinks else { return [] }
        for story in stories {
            let newStory = Story(thumbnail: story.thumbnail ?? "",
                                 mediaType: story.mediaType ?? "",
                                 url: story.url ?? "")
            newStories.append(newStory)
        }
        return newStories
    }
}

//struct Stories {
//    let stories: [Story]
//
//    init?(storiesData: StoriesData) {
//        self.stories = Story.getStories(storiesData: storiesData)
//    }
//}
//
//struct Story {
//    let createdTimeAgo: String
//    let imageThumbnail: String
//    let originalImage: String
//    let highVideo: String
//
//    static func getStories(storiesData: StoriesData) -> [Story] {
//        var stories = [Story]()
//        guard let storiesData = storiesData.data?.first else { return [] }
//
//        for story in storiesData {
//            let newStory = Story(createdTimeAgo: story.createdTime?.humanized ?? "Null",
//                                 imageThumbnail: story.images?.thumbnail ?? "",
//                                 originalImage: story.images?.original?.high ?? "",
//                                 highVideo: story.videos?.standard ?? "")
//            stories.append(newStory)
//        }
//
//        return stories
//    }
//}
