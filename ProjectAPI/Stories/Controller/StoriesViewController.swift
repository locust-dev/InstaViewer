//
//  StoriesViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 25.06.2021.
//

import UIKit
import AVKit

private let reuseIdentifier = "cell"

class StoriesViewController: UICollectionViewController {
    
    var username: String!
    var stories: [Story]!
    private var thumbnails = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = username
        fetchThumbnails()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        thumbnails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StoriesCell
        cell.storyThumbnail.image = thumbnails[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = stories[indexPath.item].mediaType
        let storyUrl = stories[indexPath.item].url
        
        if type == "video" {
            play(urlString: storyUrl)
        } else {
            performSegue(withIdentifier: "toDetail", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        guard let detailVC = segue.destination as? DetailPostViewController else { return }
        detailVC.storyImageUrl = stories[indexPath.item].url
    }
    
    private func fetchThumbnails() {
        DispatchQueue.global().async {
            for story in self.stories {
                var thumbnailUrl = story.thumbnail
                if thumbnailUrl == "" {
                    thumbnailUrl = story.url
                }
                NetworkService.shared.fetchImage(url: thumbnailUrl) { imageData in
                    guard let image = UIImage(data: imageData) else {
                        self.thumbnails.append(UIImage(systemName: "xmark")!)
                        return
                    }
                    self.thumbnails.append(image)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    private func play(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
}

// MARK: - Collection view flow layout
extension StoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let avalibleWidth = collectionView.frame.width - (itemsPerRow + 1)
        let widthPerItem = avalibleWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
}
