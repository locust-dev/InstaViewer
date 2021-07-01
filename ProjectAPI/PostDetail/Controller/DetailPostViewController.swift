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
    @IBOutlet weak var postImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var userInfoStack: UIStackView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
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
            
            NetworkService.shared.fetchImage(urlString: urlForImage) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.postImage.image = image
                        let ratio = image.size.width / image.size.height
                        let heightForImage = self.postImage.frame.width / ratio
                        let heightForView = heightForImage - self.imageHeight.constant
                        self.imageHeight.constant = heightForImage
                        self.contentViewHeight.constant += heightForView
                    case .failure(_):
                        self.postImage.image = UIImage(systemName: "xmark")
                    }
                    self.view.layoutIfNeeded()
                    self.indicatorForImage.stopAnimating()
                }
            }
        }
    }
    
    private func fetchProfileImage() {
        NetworkService.shared.fetchImage(urlString: avatar ?? "") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.profileImage.image = image
                case .failure(_):
                    self.profileImage.image = UIImage(named: "nullProfileImage")
                }
            }
        }
    }
    
    private func setupUI() {
        indicatorForImage.startAnimating()
        if let post = post {
            likesCount.text = "Likes: \(post.likesCount)"
            usernameLabel.text = username
            profileImage.layer.cornerRadius = profileImage.frame.height / 2
        } else {
            //userInfoStack.isHidden = true
            infoStackHeight.constant = 0
            postImageTopConstraint.constant = 0
        }
    }
    
}
