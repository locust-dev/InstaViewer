//
//  DetailPostViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 17.06.2021.
//

import UIKit

class DetailPostViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var indicatorForImage: UIActivityIndicatorView!
    
    var storyImageUrl: String?
    var post: Post?
    var username: String?
    var avatar: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchOriginalImage()
        fetchProfileImage()
    }
    
    private func fetchOriginalImage() {
        DispatchQueue.global().async {
            var urlForImage = ""
            
            if let post = self.post {
                urlForImage = post.originalPostImage
            } else if let storyImageUrl = self.storyImageUrl {
                urlForImage = storyImageUrl
            } else { return }
            
            NetworkService.shared.fetchImage(url: urlForImage) { imageData in
                DispatchQueue.main.async {
                    guard let image = UIImage(data: imageData) else {
                        self.postImage.image = UIImage(systemName: "xmark")
                        return
                    }
                    self.postImage.image = image
                    let ratio = image.size.width / image.size.height
                    let newHeight = self.postImage.frame.width / ratio
                    self.imageHeight.constant = newHeight
                    self.view.layoutIfNeeded()
                    self.indicatorForImage.stopAnimating()
                }
            }
        }
    }
    
    private func fetchProfileImage() {
        guard let avatar = avatar else {
            profileImage.image = UIImage(named: "nullProfileImage")
            return
        }
        NetworkService.shared.fetchImage(url: avatar) { imageData in
            guard let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                self.profileImage.image = image
            }
        }
    }
    
    private func setupUI() {
        if let post = post {
            likesCount.text = "Likes: \(post.likesCount)"
        }
        usernameLabel.text = username
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        indicatorForImage.startAnimating()
    }
    
}
