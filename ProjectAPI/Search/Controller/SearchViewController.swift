//
//  SearchViewController.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 16.06.2021.
//

import UIKit
import CoreData

protocol SearchCellDelegate {
    func deleteRows(indexPath: IndexPath)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private let storage = SearchStorageManager.shared
    private var searchedResults: [SearchedUser]?
    private var profileAvatars = [UIImage]()
    private var choseUsers = [ChoseSearchedUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersFromStorage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let profileVC = segue.destination as? ProfileViewController else { return }
        guard let results = searchedResults else {
            profileVC.title = choseUsers[indexPath.row].username
            return
        }
        profileVC.title = results[indexPath.row].username
    }
}
// MARK: - Table View Data Source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedResults?.count ?? choseUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        
        guard let results = searchedResults else {
            let choseUser = choseUsers[indexPath.row]
            cell.cachedUser = choseUser
            cell.delegate = self
            cell.profileUsername.text = choseUser.username
            cell.profileDescription.text = choseUser.userDescription
            cell.deleteButton.isHidden = false
            guard let avatar = choseUser.avatar else { return cell }
            guard let decodedData = Data(base64Encoded: avatar, options: .ignoreUnknownCharacters) else { return cell }
            cell.profileImage.image = UIImage(data: decodedData)
            return cell
        }
        
        cell.deleteButton.isHidden = true
        if profileAvatars.count == searchedResults?.count {
            cell.profileImage.image = profileAvatars[indexPath.row]
        } else {
            cell.profileImage.image = UIImage(named: "nullProfileImage")
        }
        
        cell.profileUsername.text = results[indexPath.row].username
        cell.profileDescription.text = results[indexPath.row].extraDescription
        return cell
    }
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let users = searchedResults else {
            accountGlobal = choseUsers[indexPath.row].username ?? ""
            return
        }
        
        let user = users[indexPath.row]
        accountGlobal = user.username
        
        guard let encodedAvatar = profileAvatars[indexPath.row].jpegData(compressionQuality: 1)?.base64EncodedString() else { return }
        storage.save(user: user, avatar: encodedAvatar) { user in
            self.choseUsers.append(user)
        }
    }
    
}


// MARK: - Configure Search Bar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" else { return }
        searchUserGlobal = text
        indicator.startAnimating()
        searchedResults = []
        tableView.reloadData()
        view.endEditing(true)
        DispatchQueue.global().async {
            self.searchUsers()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchedResults = nil
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

// MARK: Private Methods
extension SearchViewController {
    private func getUsersFromStorage() {
        storage.fetchData { result in
            switch result {
            case .success(let users): choseUsers = users
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }
    
    private func searchUsers() {
        SearchNetworkService.fetchSearchedUsers(url: urlForSearch) { results in
            self.searchedResults = results.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
            }
            self.fetchAvatars(from: results.results)
        }
    }
    
    private func fetchAvatars(from users: [SearchedUser]) {
        profileAvatars.removeAll()
        for user in users {
            NetworkService.shared.fetchImage(urlString: user.picture ?? "") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.profileAvatars.append(image)
                        self.tableView.reloadData()
                    case .failure(_):
                        let image = UIImage(named: "nullProfileImage")!
                        self.profileAvatars.append(image)
                    }
                }
            }
        }
    }
    
}

// MARK: - Search Cell Delegate
extension SearchViewController: SearchCellDelegate {
    func deleteRows(indexPath: IndexPath) {
        choseUsers.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
