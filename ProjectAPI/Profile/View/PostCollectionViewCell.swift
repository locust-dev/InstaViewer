//
//  ImageCollectionViewCell.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var playIcon: UIImageView!
    
    func configure(type: TypeOfPost, image: UIImage) {
        postImage.image = image
        if type == .video {
            playIcon.isHidden = false
        } else {
            playIcon.isHidden = true
        }
    }
    
}
