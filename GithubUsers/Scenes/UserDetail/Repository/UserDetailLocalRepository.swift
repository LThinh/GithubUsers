//
//  UserDetailLocalRepository.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation

protocol UserDetailLocalRepository {
    func cache(user: GithubUser, completion: @escaping ((Result<Void, Failure>) -> Void))
    func fetch(username: String, completion: @escaping ((Result<GithubUser, Failure>) -> Void))
    func remove(username: String, completion: @escaping ((Result<Void, Failure>) -> Void))
}

class CoreDataCacheUserDetail: UserDetailLocalRepository {
    static var users = [GithubUser]()
    func cache(user: GithubUser, completion: @escaping ((Result<Void, Failure>) -> Void)) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            CoreDataCacheUserDetail.users.append(user)
            DispatchQueue.main.async {
                completion(.success(()))
            }
        }
    }
    
    func fetch(username: String, completion: @escaping ((Result<GithubUser, Failure>) -> Void)) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            if let user = CoreDataCacheUserDetail.users.first(where: { $0.username == username }) {
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.noInternetConnection))
                }
            }
        }
    }
    
    func remove(username: String, completion: @escaping ((Result<Void, Failure>) -> Void)) {
        // TODO: implement later
    }
}
