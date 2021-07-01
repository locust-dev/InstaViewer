//
//  ImageCollectionViewCell.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var playIcon: UIImageView!
    
    func configure(type: TypeOfPost) {
        switch type {
        case .video:
            playIcon.isHidden = false
        case .image:
            playIcon.isHidden = false
            playIcon.image = UIImage(systemName: "rectangle.stack.person.crop")
        case .sidecar:
            playIcon.isHidden = true
        }
    }
    
}
