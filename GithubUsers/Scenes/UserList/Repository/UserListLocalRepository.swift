//
//  UserListLocalRepository.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation

protocol UserListLocalRepository {
    func cache(users: [GithubUser], completion: @escaping ((Result<Void, Failure>) -> Void))
    func fetch(completion: @escaping ((Result<[GithubUser], Failure>) -> Void))
    func remove(users: [GithubUser], completion: @escaping ((Result<Void, Failure>) -> Void))
}

class CoreDataCacheUserList: UserListLocalRepository {
    private static var users = [GithubUser]()
    
    func cache(users: [GithubUser], completion: @escaping ((Result<Void, Failure>) -> Void)) {
        DispatchQueue.global().async {
            CoreDataCacheUserList.users.append(contentsOf: users)
            completion(.success(()))
        }
    }
    
    func fetch(completion: @escaping ((Result<[GithubUser], Failure>) -> Void)) {
        DispatchQueue.global().async {
            print("Getting from cache")
            completion(.success(CoreDataCacheUserList.users))
        }
    }
    
    func remove(users: [GithubUser], completion: @escaping ((Result<Void, Failure>) -> Void)) {
        // TODO
    }
}
