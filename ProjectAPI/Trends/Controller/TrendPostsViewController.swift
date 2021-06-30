//
//  TrendPostsViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 17.06.2021.
//

import UIKit
import AVKit

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
        TrendsNetworkService.fetchTrendPosts(from: MainApi.urlForTrends) { loadedPosts in
            self.posts = loadedPosts.posts
            self.fetchImagesFromPosts()
        }
    }
    
    private func fetchImagesFromPosts() {
        guard let posts = posts else { return }
        for post in posts {
            NetworkService.shared.fetchImage(urlString: post.squarePostImage.first ?? "") { result in
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        
        if images.isEmpty {
            cell.image.image = UIImage(named: "nullCellImage")
            return cell
        }
        
        cell.image.image = images[indexPath.item]
        guard let posts = posts else { return cell }
        cell.configure(type: posts[indexPath.row].type)
        return cell
    }
    
}

// MARK: - Collection view FlowLayout
extension TrendPostsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width - 4) / 3
        return CGSize(width: side, height: side)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
}

// MARK: - Configure Search Bar
extension TrendPostsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        MainApi.hashTagForTrendGlobal = searchBar.text ?? ""
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
