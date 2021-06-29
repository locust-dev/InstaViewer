//
//  StoriesCell.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 25.06.2021.
//

import UIKit

class StoriesCell: UICollectionViewCell {
    
    @IBOutlet weak var storyThumbnail: UIImageView!
    @IBOutlet weak var playIcon: UIImageView!
    
    var story: Story? {
        didSet {
            print(story?.mediaType)
            if story?.mediaType == .video {
                playIcon.isHidden = false
            } else {
                playIcon.isHidden = true
            }
        }
    }
    
    func configureCell(image: UIImage) {
        storyThumbnail.layer.cornerRadius = 25
        storyThumbnail.layer.masksToBounds = true
        storyThumbnail.image = image
    }
    
}
