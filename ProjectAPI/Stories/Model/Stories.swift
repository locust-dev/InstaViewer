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

enum StoryType {
    case video
    case image
}

struct Story {
    let thumbnail: String
    let mediaType: StoryType
    let url: String
    
    static func getStories(storiesData: StoriesData) -> [Story] {
        var newStories = [Story]()
        guard let stories = storiesData.downloadLinks else { return [] }
        for story in stories {
            var type: StoryType {
                switch story.mediaType {
                case "image": return .image
                default: return .video
                }
            }
            
            let newStory = Story(thumbnail: story.thumbnail ?? "",
                                 mediaType: type,
                                 url: story.url ?? "")
            newStories.append(newStory)
        }
        return newStories
    }
}
