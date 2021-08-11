//
//  UserDetailService.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation

protocol UserDetailService {
    func getUserDetail(username: String, completion: @escaping (Result<GithubUser, Failure>) -> Void)
}
