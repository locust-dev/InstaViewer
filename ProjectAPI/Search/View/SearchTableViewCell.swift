//
//  SearchTableViewCell.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = profileImage.frame.height / 2
        }
    }
    
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    
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
    
}

extension SearchTableViewCell {
    
    var tableView: UITableView? {
        return superview as? UITableView
    }

    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}
