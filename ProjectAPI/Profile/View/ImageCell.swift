//
//  ImageCollectionViewCell.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var playIcon: UIImageView!
    
    var post: Post? {
        didSet {
            if post?.type == .video {
                playIcon.isHidden = false
            } else {
                playIcon.isHidden = true
            }
        }
    }
    
}
