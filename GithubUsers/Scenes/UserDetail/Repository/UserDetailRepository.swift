//
//  UserDetailRepository.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation

class UserDetailRepository: UserDetailService {
    private let remoteRepository: UserDetailRemoteRepository
    private let localRepository: UserDetailLocalRepository
    private let networkHelper: NetworkHelper
    
    init(
        remoteRepository: UserDetailRemoteRepository,
        localRepository: UserDetailLocalRepository,
        networkChecker: NetworkHelper) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
        self.networkHelper = networkChecker
    }
    
    func getUserDetail(username: String, completion: @escaping (Result<GithubUser, Failure>) -> Void) {
        if networkHelper.isNetworkAvailable {
            remoteRepository.getUserDetail(username: username) { [weak self] result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let user):
                    self?.localRepository.cache(user: user, completion: { _ in
                        // Return user detail even caching fail
                        completion(.success(user))
                    })
                }
            }
        } else {
            localRepository.fetch(username: username, completion: completion)
        }
    }
}
