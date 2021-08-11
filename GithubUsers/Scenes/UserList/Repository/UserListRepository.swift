//
//  UserListRepository.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation

class UserListRepository: UserListService {
    private let remoteRepository: UserListRemoteRepository
    private let localRepository: UserListLocalRepository
    private let networkHelper: NetworkHelper
    
    init(
        remoteRepository: UserListRemoteRepository,
        localRepository: UserListLocalRepository,
        networkChecker: NetworkHelper) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
        self.networkHelper = networkChecker
    }
    
    func getListUser(completion: @escaping (Result<[GithubUser], Failure>) -> Void) {
        if networkHelper.isNetworkAvailable {
            print("Getting data from server")
            remoteRepository.getListUser { [weak self] result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let users):
                    self?.localRepository.cache(users: users, completion: { _ in
                        // Return list users even caching fail
                        completion(.success(users))
                    })
                }
            }
        } else {
            print("Getting data from cache")
            localRepository.fetch(completion: completion)
        }
    }
}
