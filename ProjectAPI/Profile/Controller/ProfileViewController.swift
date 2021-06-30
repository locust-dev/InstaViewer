//
//  ProfileViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

import UIKit
import AVKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var indicatorForInfo: UIActivityIndicatorView!
    @IBOutlet weak var accountInfo: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileAvatar: UIImageView!
    
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var followed: UILabel!
    @IBOutlet weak var follow: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var biography: UILabel!
    @IBOutlet weak var isPrivateLabel: UILabel!
    
    private var account: Account?
    private var accountPosts: [Post]?
    private var stories: [Story]?
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileAvatar.layer.cornerRadius = profileAvatar.frame.height / 2
        indicatorForInfo.startAnimating()
        fetchAccount()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStories" {
            guard let storiesVC = segue.destination as? StoriesViewController else { return }
            guard let stories = stories else { return }
            storiesVC.stories = stories
            storiesVC.username = account?.userName
        } else if segue.identifier == "toDetail" {
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            guard let detailVC = segue.destination as? DetailPostViewController else { return }
            guard let posts = accountPosts else { return }
            detailVC.post = posts[indexPath.item]
            detailVC.username = account?.userName
            detailVC.avatar = account?.profileImage
        }
    }
    
}

// MARK: - Private methods
extension ProfileViewController {
    
    private func setupStoryBorder() {
        profileAvatar.layer.borderWidth = 4
        profileAvatar.layer.borderColor = CGColor(red: 255/255, green: 130/255, blue: 0/255, alpha: 1)
    }
    
    private func fetchAccount() {
        ProfileNetworkService.fetchAccountInfo(from: MainApi.urlForAccountInfo) { account in
            self.account = account
            MainApi.idForStoriesGlobal = account.id
            DispatchQueue.main.async {
                self.setupAccountUI()
            }
            self.fetchProfileImage(avatarUrl: account.profileImage)
            self.fetchStories()
            self.fetchPosts()
        }
    }
    
    private func fetchPosts() {
        ProfileNetworkService.fetchProfilePosts(from: MainApi.urlForPosts) { loadedPosts in
            self.accountPosts = loadedPosts.posts
            guard let posts = loadedPosts.posts else { return }
            for post in posts {
                NetworkService.shared.fetchImage(urlString: post.squarePostImage.first ?? "") { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let image):
                            self.images.append(image)
                            self.collectionView.reloadData()
                        case .failure(_):
                            return
                        }
                    }
                }
            }
        }
    }
    
    private func fetchProfileImage(avatarUrl: String) {
        NetworkService.shared.fetchImage(urlString: avatarUrl) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.profileAvatar.image = image
                case .failure(_):
                    self.profileAvatar.image = UIImage(systemName: "nullProfileImage")
                }
            }
        }
    }
    
    private func fetchStories() {
        if MainApi.idForStoriesGlobal != 0 {
            StoriesNetworkService.fetchStories(from: StoriesApi.urlForStories) { stories in
                self.stories = stories
                DispatchQueue.main.async {
                    if !stories.isEmpty {
                        self.setupStoryBorder()
                        self.setupGestures()
                    }
                }
            }
        }
    }
    
    private func setupAccountUI() {
        guard let account = account else { return }
        if account.isPrivate {
            isPrivateLabel.isHidden = false
            collectionView.isHidden = true
        }
        title = "\(account.userName)"
        indicatorForInfo.stopAnimating()
        accountInfo.isHidden = false
        postsCount.text = account.postsCountString
        followed.text = account.followedString
        follow.text = account.followString
        fullName.text = account.fullName
        biography.text = account.biography
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        profileAvatar.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapped() {
        performSegue(withIdentifier: "toStories", sender: nil)
    }
    
}


// MARK: - Collection view Delegate & DataSourse
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        
        if images.isEmpty {
            cell.image.image = UIImage(named: "nullCellImage")
            return cell
        }
        
        cell.image.image = images[indexPath.item]
        guard let posts = accountPosts else { return cell }
        cell.configure(type: posts[indexPath.row].type)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let posts = accountPosts else { return }
        let post = posts[indexPath.item]
        
        switch post.type {
        case .video: play(urlString: post.video)
        case .image: performSegue(withIdentifier: "toDetail", sender: nil)
        case .sidecar: performSegue(withIdentifier: "toDetail", sender: nil)
        }
    }
    
}

// MARK: - Collection view FlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width - 4) / 3
        return CGSize(width: side, height: side)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
}
