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
    @IBOutlet weak var userInfoStack: UIStackView!
    @IBOutlet weak var indicatorForImage: UIActivityIndicatorView!
    
    @IBOutlet weak var postImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoStackHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var imageUrl: String?
    var post: Post?
    var username: String?
    var avatar: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchProfileImage()
        fetchOriginalImage()
    }
    
    // MARK: - Fetching methods
    private func fetchOriginalImage() {
        DispatchQueue.global().async {
            let url = self.createUrl()
            NetworkService.shared.fetchImage(urlString: url) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.postImage.image = image
                        self.resizeImageView(image)
                    case .failure(_):
                        self.postImage.image = UIImage(named: "nullCellImage")
                    }
                }
            }
        }
    }
    
    private func fetchProfileImage() {
        guard let avatar = avatar else { return }
        NetworkService.shared.fetchImage(urlString: avatar) { result in
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
    
    
    // MARK: - Additional methods
    private func createUrl() -> String {
        guard let imageUrl = imageUrl else {
            guard let post = post else { return "" }
            return post.originalPostImage
        }
        return imageUrl
    }
    
    private func setupUI() {
        indicatorForImage.startAnimating()
        if let post = post {
            likesCount.text = "Likes: \(post.likesCount)"
            usernameLabel.text = username
            profileImage.layer.cornerRadius = profileImage.frame.height / 2
        } else {
            infoStackHeight.constant = 0
            postImageTopConstraint.constant = 0
        }
    }
    
    private func resizeImageView(_ image: UIImage) {
        let ratio = image.size.width / image.size.height
        let heightForImage = self.postImage.frame.width / ratio
        let heightForView = heightForImage - self.imageHeight.constant
        self.imageHeight.constant = heightForImage
        self.contentViewHeight.constant += heightForView
        self.view.layoutIfNeeded()
        self.indicatorForImage.stopAnimating()
    }
    
}
