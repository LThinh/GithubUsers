//
//  Failure.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation

/// Error Wrapper
struct Failure: Error {
    var localizedDescription: String
    let code: Int
    
    init(message: String? = nil, code: Int = 0) {
        self.code = code
        self.localizedDescription = message ?? ""
    }
    
    init(error: Error) {
        self.localizedDescription = error.localizedDescription
        self.code = 0
    }
    
    static let invalidResponse = Failure(message: "Server returns data in a wrong format", code: 400)
    static let noResponse = Failure(message: "Server returns no information", code: 400)
    static let noInternetConnection = Failure(message: "No Internet connection", code: -1_005)
    static let unauthorized = Failure(message: "Session Expired", code: 401)
}
