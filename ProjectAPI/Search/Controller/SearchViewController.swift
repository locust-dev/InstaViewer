//
//  SearchViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var searchedResults: [SearchedUser]?
    private var profileAvatars = [UIImage]()
    
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let users = searchedResults else { return }
        accountGlobal = users[indexPath.row].username
    }
}

// MARK: - Table View Data Source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        guard let results = searchedResults else { return cell }
        
        if profileAvatars.count == searchedResults?.count {
            cell.profileImage.image = profileAvatars[indexPath.row]
        } else {
            cell.profileImage.image = UIImage(named: "nullProfileImage")
        }
        
        cell.profileName.text = results[indexPath.row].username
        cell.profileFullname.text = results[indexPath.row].fullname
        return cell
    }
}

// MARK: - Configure Search Bar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchUserGlobal = searchBar.text ?? ""
        indicator.startAnimating()
        searchedResults?.removeAll()
        tableView.reloadData()
        view.endEditing(true)
        DispatchQueue.global().async {
            self.searchUsers()
        }
    }
}

// MARK: Private Methods
extension SearchViewController {
    private func searchUsers() {
        NetworkSearchService.shared.fetchSearchedUsers(url: urlForSearch) { results in
            guard let searchResults = results else { return }
            self.searchedResults = searchResults.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
            }
            self.fetchAvatars(from: searchResults.results)
        }
    }
    
    private func fetchAvatars(from users: [SearchedUser]) {
        profileAvatars.removeAll()
        for user in users {
            NetworkSearchService.shared.fetchSearchedUserAvatar(user: user) { imageData in
                guard let data = imageData else {
                    self.profileAvatars.append(UIImage(systemName: "xmark")!)
                    return
                }
                guard let image = UIImage(data: data) else {
                    self.profileAvatars.append(UIImage(systemName: "xmark")!)
                    return
                }
                self.profileAvatars.append(image)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
