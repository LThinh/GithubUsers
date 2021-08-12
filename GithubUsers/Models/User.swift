//
//  User.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation

struct GithubUser: Codable {
    let id: Int
    let avatarUrl: String?
    let username: String
    let name: String?
    let url: String
    let location: String?
    let bio: String?
    let publicRepos: Int?
    let followers: Int?
    let following: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case avatarUrl = "avatar_url"
        case username = "login"
        case name
        case url
        case location
        case bio
        case publicRepos = "public_repos"
        case followers
        case following
    }
}
