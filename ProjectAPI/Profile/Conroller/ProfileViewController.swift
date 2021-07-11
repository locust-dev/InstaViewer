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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var accountInfo: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var mainStackHeight: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var followed: UILabel!
    @IBOutlet weak var follow: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var biography: UILabel!
    @IBOutlet weak var isPrivateLabel: UILabel!
    @IBOutlet weak var website: UILabel!
    
    var username: String? = MainApi.defaultUser
    
    private var account: Account?
    private var stories: Stories?
    private var hasNextPage: Bool?
    private var idForStories: Int?
    private var accountPosts = [Post]()
    private var pageId = String()
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStackHeight.constant = view.frame.height
        indicatorForInfo.startAnimating()
        configureRefreshControl()
        fetchAccount()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStories" {
            guard let storiesVC = segue.destination as? StoriesViewController else { return }
            guard let stories = stories else { return }
            storiesVC.storiesData = stories
            storiesVC.username = account?.username
        } else if segue.identifier == "toDetail" {
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            guard let detailVC = segue.destination as? DetailPostViewController else { return }
            guard !accountPosts.isEmpty else { return }
            detailVC.post = accountPosts[indexPath.item]
            detailVC.username = account?.username
            detailVC.avatar = account?.profileImage
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                mainStackHeight.constant = newSize.height + mainView.frame.height
            }
        }
    }
    
}

// MARK: - Private methods
extension ProfileViewController {
    
    private func fetchAccount() {
        guard let username = username else { return }
        ProfileNetworkService.fetchAccountInfo(username: username) { result in
            switch result {
            case .success(let account):
                self.account = account
                self.idForStories = account.id
                self.fetchProfileImage(account.profileImage)
                DispatchQueue.main.async {
                    self.setupAccountUI(account)
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.indicatorForInfo.stopAnimating()
                    self.isPrivateLabel.isHidden = false
                    self.isPrivateLabel.text = "Something went wrong. Try to refresh the page."
                }
            }
        }
    }
    
    private func fetchPosts() {
        DispatchQueue.main.async {
            self.collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            if self.images.isEmpty {
                self.indicatorForPosts.startAnimating()
            }
        }
        guard let username = username else { return }
        ProfileNetworkService.fetchPosts(username: username, pageId: pageId) { result in
            switch result {
            case .success(let postsData):
                let posts = postsData.posts
                self.accountPosts += posts
                self.hasNextPage = postsData.hasNextPage
                self.pageId = postsData.pageId

                for post in posts {
                    self.fetchPostImage(post: post)
                }
                DispatchQueue.main.async {
                    guard let nextPage = self.hasNextPage else { return }
                    if nextPage {
                        self.scrollView.delegate = self
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    private func fetchPostImage(post: Post) {
        NetworkService.shared.fetchImage(urlString: post.squarePostImage) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.images.append(image)
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                    self.indicatorForPosts.stopAnimating()
                case .failure(let error):
                    print(error.localizedDescription)
                    self.images.append(UIImage(named: "nullCellImage")!)
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
                case .failure(let error):
                    print(error.localizedDescription)
                    self.avatar.image = UIImage(named: "nullProfileImage")
                }
            }
        }
    }
    
    private func fetchStories() {
        guard let id = idForStories else { return }
        let url = StoriesApi.getUrlForStories(id: id)
        StoriesNetworkService.fetchStories(url, id: id) { result in
            switch result {
            case .success(let stories):
                self.stories = stories
                DispatchQueue.main.async {
                    self.setupStoryBorder()
                    self.setupGestures()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupAccountUI(_ account: Account) {
        avatar.layer.cornerRadius = avatar.frame.height / 2
        title = "\(account.username)"
        indicatorForInfo.stopAnimating()
        accountInfo.isHidden = false
        postsCount.text = account.postsCountString
        followed.text = account.followersString
        follow.text = account.followingsString
        fullName.text = account.fullname
        biography.text = account.biography
        website.text = account.website
        
        if account.isPrivate {
            self.isPrivateLabel.isHidden = false
        } else if account.postsCount == 0 {
            self.isPrivateLabel.isHidden = false
            self.isPrivateLabel.text = "\(account.username) doesn't have any posts yet"
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

// MARK: - Collection view Delegate
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
            cell.configure(type: accountPosts[indexPath.row].type, image: images[indexPath.item])
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
        
        if indexPath.item == images.count {
            return CGSize(width: collectionView.frame.width, height: 80)
        } else {
            let itemPerRow: CGFloat = 3
            let side = (collectionView.frame.width - 4) / itemPerRow
            return CGSize(width: side, height: side)
        }
    }
    
    
}

// MARK: - Scroll view configure
extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            fetchPosts()
            scrollView.delegate = nil
        }
    }
    
    private func configureRefreshControl () {
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.tintColor = .white
        scrollView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self = self else { return }
            self.isPrivateLabel.isHidden = true
            self.scrollView.refreshControl?.endRefreshing()
            self.account = nil
            self.stories = nil
            self.hasNextPage = nil
            self.idForStories = nil
            self.accountPosts.removeAll()
            self.pageId = ""
            self.images.removeAll()
            self.accountInfo.isHidden = true
            self.viewDidLoad()
            self.collectionView.reloadData()
            DispatchQueue.global().async {
                self.fetchAccount()
            }
        }
    }
    
}
