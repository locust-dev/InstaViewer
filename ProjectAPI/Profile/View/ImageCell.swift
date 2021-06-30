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
    
    func configure(type: TypeOfPost) {
        if type == .video {
            playIcon.isHidden = false
        } else if type == .sidecar {
            playIcon.isHidden = false
            playIcon.image = UIImage(systemName: "rectangle.stack.person.crop")
        } else {
            playIcon.isHidden = true
        }
    }
    
}
