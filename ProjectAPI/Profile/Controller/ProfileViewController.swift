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
    @IBOutlet weak var indicatorForPosts: UIActivityIndicatorView!
    @IBOutlet weak var accountInfo: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var followed: UILabel!
    @IBOutlet weak var follow: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var biography: UILabel!
    @IBOutlet weak var isPrivateLabel: UILabel!
    
    var username: String? = "varlamov"
    
    private var account: Account?
    private var stories: [Story]?
    private var hasNextPage: Bool?
    private var idForStories: Int?
    private var accountPosts = [Post]()
    private var pageId = String()
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            guard !accountPosts.isEmpty else { return }
            detailVC.post = accountPosts[indexPath.item]
            detailVC.username = account?.userName
            detailVC.avatar = account?.profileImage
        }
    }
    
}

// MARK: - Private methods
extension ProfileViewController {
    
    private func fetchAccount() {
        guard let username = username else { return }
        ProfileNetworkService.fetchAccountInfo(username: username) { account in
            self.account = account
            self.idForStories = account.id
            self.fetchProfileImage(account.profileImage)
            DispatchQueue.main.async {
                self.setupAccountUI(account)
            }
        }
    }
    
    private func fetchPosts() {
        DispatchQueue.main.async {
            if self.images.isEmpty {
                self.indicatorForPosts.startAnimating()
            }
        }
        guard let username = username else { return }
        ProfileNetworkService.fetchProfilePosts(username: username, pageId: pageId) { loadedPosts in
            guard let posts = loadedPosts.posts else { return }
            self.accountPosts += posts
            self.hasNextPage = loadedPosts.hasNextPage
            self.pageId = loadedPosts.pageId
            guard let posts = loadedPosts.posts else { return }
            for post in posts {
                self.fetchPostImage(post: post)
            }
        }
    }
    
    private func fetchPostImage(post: Post) {
        NetworkService.shared.fetchImage(urlString: post.squarePostImage.first ?? "") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.images.append(image)
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                    self.indicatorForPosts.stopAnimating()
                case .failure(_):
                    return
                }
            }
        }
    }
    
    private func fetchProfileImage(_ avatarUrl: String) {
        NetworkService.shared.fetchImage(urlString: avatarUrl) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.avatar.image = image
                case .failure(_):
                    self.avatar.image = UIImage(named: "nullProfileImage")
                }
            }
        }
    }
    
    private func fetchStories() {
        guard let id = idForStories else { return }
        StoriesNetworkService.fetchStories(id: id) { stories in
            self.stories = stories
            DispatchQueue.main.async {
                if !stories.isEmpty {
                    self.setupStoryBorder()
                    self.setupGestures()
                }
            }
        }
    }
    
    private func setupAccountUI(_ account: Account) {
        avatar.layer.cornerRadius = avatar.frame.height / 2
        title = "\(account.userName)"
        indicatorForInfo.stopAnimating()
        accountInfo.isHidden = false
        postsCount.text = account.postsCountString
        followed.text = account.followedString
        follow.text = account.followString
        fullName.text = account.fullName
        biography.text = account.biography
        
        if account.isPrivate {
            self.isPrivateLabel.isHidden = false
            self.collectionView.isHidden = true
        } else {
            DispatchQueue.global().async {
                self.fetchStories()
                self.fetchPosts()
            }
        }
    }
    
    private func setupStoryBorder() {
        avatar.layer.borderWidth = 4
        avatar.layer.borderColor = CGColor(red: 255/255, green: 130/255, blue: 0/255, alpha: 1)
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        avatar.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapped() {
        performSegue(withIdentifier: "toStories", sender: nil)
    }
    
}

// MARK: - Collection view DataSourse
extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !accountPosts.isEmpty else { return }
        let post = accountPosts[indexPath.item]
        switch post.type {
        case .video: play(urlString: post.video)
        case .image: performSegue(withIdentifier: "toDetail", sender: nil)
        case .sidecar: performSegue(withIdentifier: "toDetail", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let hasNextPage = hasNextPage else { return }
        if indexPath.row == accountPosts.count && hasNextPage {
            fetchPosts()
            print("showed")
        }
    }
}

// MARK: - Collection view DataSourse
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count > 0 {
            if images.count == account?.postsCount {
                return images.count
            }
            return images.count + 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != images.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCollectionViewCell
            cell.image.image = images[indexPath.item]
            cell.configure(type: accountPosts[indexPath.row].type)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "indicatorCell", for: indexPath) as! IndicatorCell
            cell.indicator.startAnimating()
            return cell
        }
    }
}

// MARK: - Collection view FlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat
        let height: CGFloat
        
        if indexPath.item == images.count {
            width = collectionView.frame.width
            height = 100
        } else {
            let itemPerRow: CGFloat = 3
            let side = (collectionView.frame.width - 4) / itemPerRow
            width = side
            height = side
        }

        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
}
