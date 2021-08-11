//
//  GithubUserCache+CoreDataProperties.swift
//  GithubUsers
//
//  Created by Thinh Le on 11/08/2021.
//
//

import Foundation
import CoreData


extension GithubUserCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GithubUserCache> {
        return NSFetchRequest<GithubUserCache>(entityName: "GithubUserCache")
    }

    @NSManaged public var avatarUrl: String?
    @NSManaged public var bio: String?
    @NSManaged public var followers: Int64
    @NSManaged public var following: Int64
    @NSManaged public var id: Int64
    @NSManaged public var location: String?
    @NSManaged public var publicRepos: Int64
    @NSManaged public var url: String?
    @NSManaged public var username: String

}

extension GithubUserCache : Identifiable {

}
