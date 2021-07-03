//
//  SearchTableViewCell.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var cachedUser: ChoseSearchedUser?
    var delegate: SearchCellDelegate?
    
    @IBAction func deleteButton(_ sender: Any) {
        guard let cachedUser = cachedUser,
              let indexPath = indexPath,
              let delegate = delegate
        else { return }
        SearchStorageManager.shared.delete(cachedUser)
        delegate.deleteRows(indexPath: indexPath)
    }
    
    func configureCached(user: ChoseSearchedUser) {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        cachedUser = user
        profileUsername.text = user.username
        profileDescription.text = user.userDescription
        deleteButton.isHidden = false
        guard let avatar = user.avatar else {
            profileImage.image = UIImage(named: "nullProfileImage")
            return
        }
        guard let decodedData = Data(base64Encoded: avatar, options: .ignoreUnknownCharacters) else { return }
        profileImage.image = UIImage(data: decodedData)
    }
    
    func configureSearched(searchedUser: SearchedUser) {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        deleteButton.isHidden = true
        profileUsername.text = searchedUser.username
        profileDescription.text = searchedUser.extraDescription
    }
}

// MARK: - Get superview and self index
extension SearchTableViewCell {
    private var tableView: UITableView? {
        return superview as? UITableView
    }

    private var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}
