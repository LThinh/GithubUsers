//
//  GithubUserCache+CoreDataClass.swift
//  GithubUsers
//
//  Created by Thinh Le on 11/08/2021.
//
//

import Foundation
import CoreData

@objc(GithubUserCache)
public class GithubUserCache: NSManagedObject {
    static var identifier: String {
        return String(describing: self)
    }
    
    func setData(from user: GithubUser) {
        self.avatarUrl = user.url
        self.id = Int64(user.id)
        self.username = user.username
        self.bio = user.bio
        self.followers = Int64(user.followers ?? 0)
        self.following = Int64(user.following ?? 0)
        self.publicRepos = Int64(user.publicRepos ?? 0)
        self.location = user.location
        self.url = user.url
    }
    
    func mapToGithubUser() -> GithubUser {
        return GithubUser(
            id: Int(id),
            avatarUrl: avatarUrl,
            username: username,
            url: url ?? "",
            location: location,
            bio: bio,
            publicRepos: Int(publicRepos),
            followers: Int(followers),
            following: Int(following))
    }
}
