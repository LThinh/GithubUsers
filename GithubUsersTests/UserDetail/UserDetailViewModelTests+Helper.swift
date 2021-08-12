//
//  UserDetailViewModelTests+Helper.swift
//  GithubUsersTests
//
//  Created by Thinh Le on 11/08/2021.
//

import Foundation
@testable import GithubUsers

extension UserDetailViewModelTests {
    // MARK: - Mock Service
    class UserDetailServiceMock: UserDetailService {
        static var response: Result<GithubUser, Failure> = .failure(.noResponse)
        
        func getUserDetail(username: String, completion: @escaping (Result<GithubUser, Failure>) -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
              completion(Self.response)
            }
        }
    }
    
    // MARK: - Helper
    func makeSut(username: String) -> UserDetailViewModel {
        let service = UserDetailServiceMock()
        let viewModel = UserDetailViewModel(username: username, service: service)
        return viewModel
    }
    
    // MARK: - Mock Data
    func getMockUser() -> GithubUser {
        let user = GithubUser(
            id: 2,
            avatarUrl: nil,
            username: "2",
            name: "hello",
            url: "",
            location: nil,
            bio: nil,
            publicRepos: 3,
            followers: 4,
            following: 2345)
        return user
    }
}
