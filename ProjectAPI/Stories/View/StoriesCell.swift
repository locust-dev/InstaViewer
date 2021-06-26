//
//  StoriesCell.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 25.06.2021.
//

import UIKit

class StoriesCell: UICollectionViewCell {
    
    @IBOutlet weak var storyThumbnail: UIImageView!
    
    func configureCell(content: (UIImage, String)) {
        storyThumbnail.layer.cornerRadius = 25
        storyThumbnail.layer.masksToBounds = true
        storyThumbnail.image = content.0
    }
    
}
