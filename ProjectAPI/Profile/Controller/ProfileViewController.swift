//
//  ProfileViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

import UIKit

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
    private var accountPosts: Posts?
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
        } else {
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            guard let detailVC = segue.destination as? DetailPostViewController else { return }
            guard let posts = accountPosts?.posts else { return }
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
        ProfileNetworkService.fetchAccountInfo(from: urlForAccountInfo) { account in
            self.account = account
            idForStoriesGlobal = account.id
            DispatchQueue.main.async {
                self.setupAccountUI()
            }
            self.fetchProfileImage(avatarUrl: account.profileImage)
            self.fetchStories()
            //self.fetchPosts()
        }
    }
    
    private func fetchPosts() {
        ProfileNetworkService.fetchProfilePosts(from: urlForPosts) { loadedPosts in
            self.accountPosts = loadedPosts
            guard let posts = loadedPosts.posts else { return }
            for post in posts {
                NetworkService.fetchImage(url: post.squarePostImage.first ?? "") { result in
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
        NetworkService.fetchImage(url: avatarUrl) { result in
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
        if idForStoriesGlobal != 0 {
            StoriesNetworkService.fetchStories(from: urlForStories2) { stories in
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
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        
        if images.isEmpty {
            cell.image.image = UIImage(named: "nullCellImage")
            return cell
        }
        cell.image.image = images[indexPath.item]
        return cell
    }
    
}

// MARK: - Collection view FlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let avalibleWidth = collectionView.frame.width - (itemsPerRow + 1)
        let widthPerItem = avalibleWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
}
