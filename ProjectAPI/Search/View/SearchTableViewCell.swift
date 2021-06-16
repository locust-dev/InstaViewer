//
//  SearchTableViewCell.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = profileImage.frame.height / 2
        }
    }
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileFullname: UILabel!
    
}
