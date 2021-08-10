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
    
    private var _networkAvailable = false
    
    var isNetworkAvailable: Bool {
        return _networkAvailable
    }
    
    let reachability: Reachability
    
    init() {
        reachability = try! Reachability()
        _networkAvailable = reachability.connection != .unavailable
        reachability.whenReachable = { [weak self] _ in
            self?._networkAvailable = true
        }
        reachability.whenUnreachable = { [weak self] _ in
            self?._networkAvailable = false
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

