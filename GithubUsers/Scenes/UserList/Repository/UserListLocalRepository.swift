//
//  UserListLocalRepository.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation
import CoreData

protocol UserListLocalRepository {
    func cache(users: [GithubUser], completion: @escaping ((Result<Void, Failure>) -> Void))
    func fetch(completion: @escaping ((Result<[GithubUser], Failure>) -> Void))
    func remove(users: [GithubUser], completion: @escaping ((Result<Void, Failure>) -> Void))
}

class CoreDataCacheUserList: UserListLocalRepository {
    func cache(users: [GithubUser], completion: @escaping ((Result<Void, Failure>) -> Void)) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.perform {
            for user in users {
                let fetchRequest: NSFetchRequest<GithubUserCache> = GithubUserCache.fetchRequest()
                let predicate = NSPredicate(format: "id==\(user.id)")
                fetchRequest.predicate = predicate
                do {
                    if let fetchedUser = try context.fetch(fetchRequest).first {
                        fetchedUser.setData(from: user)
                    }
                } catch let error {
                    dump(error.localizedDescription)
                }
                
                if let entity = NSEntityDescription.entity(
                    forEntityName: GithubUserCache.identifier,
                    in: context),
                      let cacheUser = NSManagedObject(
                        entity: entity,
                        insertInto: context) as? GithubUserCache {
                    cacheUser.setData(from: user)
                }
                do {
                    try context.save()
                } catch let error {
                    dump(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            }
        }
    }
    
    func fetch(completion: @escaping ((Result<[GithubUser], Failure>) -> Void)) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.perform {
            let fetchRequest: NSFetchRequest<GithubUserCache> = GithubUserCache.fetchRequest()
            do {
                let fetchedUsers = try context.fetch(fetchRequest)
                let users = fetchedUsers.map({ $0.mapToGithubUser() })
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.init(error: error)))
                }
            }
        }
    }
    
    func remove(users: [GithubUser], completion: @escaping ((Result<Void, Failure>) -> Void)) {
        // TODO
    }
}
