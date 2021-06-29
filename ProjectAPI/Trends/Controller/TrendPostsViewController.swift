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
    
    private var posts: [Post]?
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        detailPostVC.post = posts[indexPath.item]
    }
    
    private func fetchPosts() {
        indicator.startAnimating()
        TrendsNetworkService.fetchTrendPosts(from: urlForTrends) { loadedPosts in
            self.posts = loadedPosts.posts
            self.fetchImagesFromPosts()
        }
    }
    
    private func fetchImagesFromPosts() {
        guard let posts = posts else { return }
        for post in posts {
            NetworkService.fetchImage(url: post.squarePostImage.first ?? "") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.images.append(image)
                        self.collectionView.reloadData()
                        self.indicator.stopAnimating()
                    case .failure(_):
                        return
                    }
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
