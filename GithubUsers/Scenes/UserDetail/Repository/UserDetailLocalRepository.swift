//
//  UserDetailLocalRepository.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation
import CoreData

protocol UserDetailLocalRepository {
    func cache(user: GithubUser, completion: @escaping ((Result<Void, Failure>) -> Void))
    func fetch(username: String, completion: @escaping ((Result<GithubUser, Failure>) -> Void))
    func remove(username: String, completion: @escaping ((Result<Void, Failure>) -> Void))
}

class CoreDataCacheUserDetail: UserDetailLocalRepository {
    static var users = [GithubUser]()
    func cache(user: GithubUser, completion: @escaping ((Result<Void, Failure>) -> Void)) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        DispatchQueue.global().async {
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
    
    func fetch(username: String, completion: @escaping ((Result<GithubUser, Failure>) -> Void)) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        DispatchQueue.global().async {
            let fetchRequest: NSFetchRequest<GithubUserCache> = GithubUserCache.fetchRequest()
            let predicate = NSPredicate(format: "username==%@", username)
            fetchRequest.predicate = predicate
            do {
                if let fetchedUser = try context.fetch(fetchRequest).first {
                    DispatchQueue.main.async {
                        completion(.success(fetchedUser.mapToGithubUser()))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(.noResponse))
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.init(error: error)))
                }
            }
        }
    }
    
    func remove(username: String, completion: @escaping ((Result<Void, Failure>) -> Void)) {
        // TODO: implement later
    }
}
