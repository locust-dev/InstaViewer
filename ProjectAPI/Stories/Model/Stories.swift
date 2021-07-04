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
        guard let profilePic = storiesData.profilePic,
        let totalStories = storiesData.totalStories,
        !storiesData.downloadLinks.isEmpty else { return nil }
        
        var loadedStories = [Story]()
        for story in storiesData.downloadLinks {
            guard let story = Story(storyData: story) else { continue }
            loadedStories.append(story)
        }
        
        self.stories = loadedStories
        self.profilePic = profilePic
        self.totalStories = totalStories
    }
}

struct Story {
    let thumbnail: String
    let mediaType: StoryType
    let url: String
    
    init?(storyData: StoryData) {
        guard let thumbnail = storyData.thumbnail,
              let mediaType = storyData.mediaType,
              let url = storyData.url else { return nil }
        
        switch mediaType {
        case "video": self.mediaType = .video
        default: self.mediaType = .image
        }
        
        self.thumbnail = thumbnail
        self.url = url
    }
}

enum StoryType {
    case video
    case image
}
