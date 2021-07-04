//
//  StoriesViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 25.06.2021.
//

import UIKit
import AVKit

class StoriesViewController: UICollectionViewController {
    
    var username: String?
    var storiesData: Stories!
    private var thumbnails = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = username
        fetchThumbnails()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        guard let detailVC = segue.destination as? DetailPostViewController else { return }
        detailVC.imageUrl = storiesData.stories[indexPath.item].url
    }
    
}

// MARK: - Collection view data source
extension StoriesViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        thumbnails.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storyCell", for: indexPath) as! StoriesCell
        let image = thumbnails[indexPath.item]
        cell.configureCell(image: image)
        cell.story = storiesData.stories[indexPath.item]
        return cell
    }
}

// MARK: - Collection view delegate
extension StoriesViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let story = storiesData.stories[indexPath.item]
        story.mediaType == .video
            ? play(urlString: story.url)
            : performSegue(withIdentifier: "toDetail", sender: nil)
        
    }
}

//MARK: - Private methods
extension StoriesViewController {
    private func fetchThumbnails() {
        DispatchQueue.global().async {
            for story in self.storiesData.stories {
                let url = self.createStoryUrl(story: story)
                NetworkService.shared.fetchImage(urlString: url) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let image):
                            self.thumbnails.append(image)
                            self.collectionView.reloadData()
                        case .failure(_):
                            self.thumbnails.append(UIImage(named: "nullCellImage")!)
                        }
                    }
                }
            }
        }
    }
    
    private func createStoryUrl(story: Story) -> String {
        if story.thumbnail == "" {
            return story.url
        }
        return story.thumbnail
    }
    
}

// MARK: - Collection view delegate flow layout
extension StoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let padding = 10 * (itemsPerRow + 1)
        let avalibleWidth = collectionView.frame.width - padding
        let widthPerItem = avalibleWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
}
