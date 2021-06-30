//
//  SearchStorageManager.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 30.06.2021.
//

import CoreData

class SearchStorageManager {
    
    static let shared = SearchStorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ProjectAPI")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    func fetchData(completion: (Result<[ChoseSearchedUser], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<ChoseSearchedUser> = ChoseSearchedUser.fetchRequest()
        
        do {
            let users = try viewContext.fetch(fetchRequest)
            completion(.success(users))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func isExist(username: String) -> Bool {
        var fetchedUsers = [ChoseSearchedUser]()
        fetchData { result in
            switch result {
            case .success(let users): fetchedUsers = users
            case .failure(let error): print(error.localizedDescription)
            }
        }
        
        for user in fetchedUsers {
            if username == user.username {
                print("alredy exist")
                return true
            }
        }
        return false
    }
    
    // Work with data
    func save(user: SearchedUser, avatar: String, completion: (ChoseSearchedUser) -> Void) {
        if isExist(username: user.username) { return }
        let newUser = ChoseSearchedUser(context: viewContext)
        newUser.username = user.username
        newUser.userDescription = user.extraDescription
        newUser.avatar = avatar
        completion(newUser)
        saveContext()
    }
    
    func delete(_ user: ChoseSearchedUser) {
        viewContext.delete(user)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

