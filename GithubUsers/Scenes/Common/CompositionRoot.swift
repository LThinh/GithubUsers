//
//  CompositionRoot.swift
//  GithubUsers
//
//  Created by Thinh Le on 11/08/2021.
//

import UIKit

class CompositionRoot {
    var rootViewController: UINavigationController
    
    init() {
        // Dependency Injection
        let service = UserListRepository(
            remoteRepository: UserListRemoteRepository(),
            localRepository: CoreDataCacheUserList(),
            networkChecker: ReachabilityNetworkHelper.shared)
        let viewModel = UserListViewModel(service: service)
        let viewController = UserListViewController(viewModel: viewModel, userDetailFactory: userDetailFactory)
        rootViewController = UINavigationController(rootViewController: viewController)
    }
    
    private var userDetailFactory: ((String) -> UIViewController) = { username in
        // Dependency Injection
        let service = UserDetailRepository(
            remoteRepository: UserDetailRemoteRepository(),
            localRepository: CoreDataCacheUserDetail(),
            networkChecker: ReachabilityNetworkHelper.shared)
        let viewModel = UserDetailViewModel(username: username, service: service)
        let viewController = UserDetailViewController(viewModel: viewModel)
        return viewController
    }
}
