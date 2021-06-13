//
//  ProfileViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 13.06.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileAvatar: UIImageView!
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var followed: UILabel!
    @IBOutlet weak var follow: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var biography: UILabel!
    
    var account: Account?
    var accountPosts: AccountPosts?
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAccount()
        profileAvatar.layer.cornerRadius = profileAvatar.frame.height / 2
    }
    
    private func fetchPosts() {
        NetworkService.shared.fetchProfilePosts(from: urlForPosts) { loadedPosts in
            self.accountPosts = loadedPosts
            self.fetchImagesFromPosts()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func fetchAccount() {
        NetworkService.shared.fetchAccountInfo(from: urlForAccountInfo) { account in
            guard let account = account else { return }
            self.account = account
            DispatchQueue.main.async {
                self.postsCount.text = account.postsCountString
                self.followed.text = account.followedString
                self.follow.text = account.followString
                self.fullName.text = account.fullName
                self.biography.text = account.biography
                self.title = "\(account.userName)"
            }
            postsCountGlobal = account.postsCount
            idGlobal = account.id
            self.fetchProfileImage()
            self.fetchPosts()
        }
    }
    
    private func fetchImagesFromPosts() {
        guard let accountPosts = accountPosts else { return }
        for post in accountPosts.posts {
            guard let url = URL(string: post.postImage) else { return }
            if let data = try? Data(contentsOf: url) {
                guard let image = UIImage(data: data) else { return }
                images.append(image)
            }
        }
    }
    
    private func fetchProfileImage() {
        guard let account = account else {
            profileAvatar.image = UIImage(systemName: "xmark")
            return
        }
        guard let url = URL(string: account.profileImage) else { return }
        if let data = try? Data(contentsOf: url) {
            DispatchQueue.main.async {
                self.profileAvatar.image = UIImage(data: data)
            }
        }
    }
}

// MARK: - Collection view configure
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        accountPosts?.posts.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        
        if images.isEmpty {
            cell.image.image = UIImage(systemName: "xmark")
            return cell
        }
        cell.image.image = images[indexPath.item]
        return cell
    }
}

// MARK: - FlowLayout
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
