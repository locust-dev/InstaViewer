//
//  DetailPostViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 17.06.2021.
//

import UIKit

class DetailPostViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likesCount: UILabel!
    
    var post: Post!
    var avatar: UIImage!
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = username
        profileImage.image = avatar
        
        
    }
    
    
}
