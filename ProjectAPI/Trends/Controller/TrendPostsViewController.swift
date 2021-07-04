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
    @IBOutlet weak var wentWrong: UILabel!
    
    private var postsInfo: Posts?
    private var images = [UIImage]()
    private var hashtagForTrends = "popular"
    
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
        guard let posts = postsInfo?.posts else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        detailPostVC.post = posts[indexPath.item]
    }
    
    private func fetchPosts() {
        indicator.startAnimating()
        TrendsNetworkService.fetchTrendPosts(hashtag: hashtagForTrends) { results in
            switch results {
            case .success(let loadedPosts):
                self.postsInfo = loadedPosts
                self.fetchImagesFromPosts()
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.wentWrong.isHidden = false
                }
            }
        }
    }
    
    private func fetchImagesFromPosts() {
        guard let posts = postsInfo else { return }
        for post in posts.posts {
            NetworkService.shared.fetchImage(urlString: post.squarePostImage) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.images.append(image)
                        self.collectionView.reloadData()
                        self.indicator.stopAnimating()
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.images.append(UIImage(named: "nullCellImage")!)
                    }
                }
            }
        }
    }
    
}

// MARK: - Collection view data source
extension TrendPostsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count > 0 {
            if images.count == postsInfo?.posts.count {
                return images.count
            }
            return images.count + 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != images.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendsCell", for: indexPath) as! PostCollectionViewCell
            cell.postImage.image = images[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "indicatorCell", for: indexPath) as! IndicatorCell
            cell.indicator.startAnimating()
            return cell
        }
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
        hashtagForTrends = searchBar.text ?? ""
        indicator.startAnimating()
        images.removeAll()
        postsInfo = nil
        collectionView.reloadData()
        view.endEditing(true)
        DispatchQueue.global().async {
            self.fetchPosts()
        }
    }
}
