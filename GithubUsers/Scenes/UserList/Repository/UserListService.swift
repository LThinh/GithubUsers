//
//  UserListService.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation

protocol UserListService {
    func getListUser(completion: @escaping (Result<[GithubUser], Failure>) -> Void)
}
