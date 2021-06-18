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
    var username: String!
    var avatar: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = username
        fetchOriginalImage()
        fetchProfileImage()
    }
    
    private func fetchOriginalImage() {
        DispatchQueue.global().async {
            NetworkService.shared.fetchImage(url: self.post.originalPostImage) { imageData in
                DispatchQueue.main.async {
                    guard let data = imageData else {
                        self.postImage.image = UIImage(systemName: "xmark")
                        return
                    }
                    guard let image = UIImage(data: data) else {
                        self.postImage.image = UIImage(systemName: "xmark")
                        return
                    }
                    self.postImage.image = image
                }
            }
        }
    }
    
    private func fetchProfileImage() {
        guard let avatar = avatar else {
            profileImage.image = UIImage(systemName: "xmark")
            return
        }
        DispatchQueue.global().async {
            guard let url = URL(string: avatar) else { return }
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.profileImage.image = UIImage(data: data)
                }
            }
        }
    }
}
