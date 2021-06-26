//
//  TrendPostsViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 17.06.2021.
//

import UIKit

class TrendPostsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var posts: Posts?
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        fetchPosts()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailPostVC = segue.destination as? DetailPostViewController else { return }
        guard let posts = posts else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        detailPostVC.post = posts.posts?[indexPath.item]
    }
    
    private func fetchPosts() {
        TrendsNetworkService.shared.fetchTrendPosts(from: urlForTrends) { loadedPosts in
            self.posts = loadedPosts
            self.fetchImagesFromPosts()
        }
    }
    
    private func fetchImagesFromPosts() {
        guard let postsData = posts else { return }
        guard let posts = postsData.posts else { return }
        for post in posts {
            NetworkService.shared.fetchImage(url: post.squarePostImage.first ?? "") { imageData in
                guard let image = UIImage(data: imageData) else { return }
                self.images.append(image)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
}

extension TrendPostsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrendsCollectionViewCell
        
        if images.isEmpty {
            cell.image.image = UIImage(systemName: "xmark")
            return cell
        }
        cell.image.image = images[indexPath.item]
        return cell
    }
}

// MARK: - Collection view FlowLayout
extension TrendPostsViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - Configure Search Bar
extension TrendPostsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hashTagForTrendGlobal = searchBar.text ?? ""
        indicator.startAnimating()
        images.removeAll()
        posts = nil
        collectionView.reloadData()
        view.endEditing(true)
        DispatchQueue.global().async {
            self.fetchPosts()
        }
    }
}
