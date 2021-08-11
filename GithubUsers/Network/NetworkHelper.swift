//
//  NetworkHelper.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation
import Reachability

protocol NetworkHelper {
    var isNetworkAvailable: Bool { get }
}

class ReachabilityNetworkHelper: NetworkHelper {
    static let shared = ReachabilityNetworkHelper()
    
    var isNetworkAvailable: Bool {
        return reachability.connection != .unavailable
    }
    
    var networkStatusChanged: ((Bool) -> ())?
    
    let reachability: Reachability
    
    init() {
        reachability = try! Reachability()
        reachability.whenReachable = { [weak self] _ in
            dump("Connected")
            self?.networkStatusChanged?(true)
        }
        reachability.whenUnreachable = { [weak self] _ in
            dump("Not connected")
            self?.networkStatusChanged?(false)
        }

        do {
            try reachability.startNotifier()
        } catch {
            dump("Unable to start notifier")
        }
    }
    
    deinit {
        reachability.stopNotifier()
    }
}

