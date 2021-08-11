//
//  SceneDelegate.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // create a basic UIWindow and activate it
        window = UIWindow(windowScene: windowScene)
        
        // Dependency Injection
        let service = UserListRepository(
            remoteRepository: UserListRemoteRepository(),
            localRepository: CoreDataCacheUserList(),
            networkChecker: ReachabilityNetworkHelper.shared)
        let viewModel = UserListViewModel(service: service)
        let viewController = UserListViewController(viewModel: viewModel)
        
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
        addInternetIndicatorView()
    }
    
    /// Adding a view to indicate network status
    /// Sometime Rechability does not work properly in simulator
    private func addInternetIndicatorView() {
        guard let window = window else { return }
        let topInset = window.safeAreaInsets.top
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.frame.origin = .init(x: 4, y: topInset)
        label.frame.size = .init(width: 100, height: 10)
        ReachabilityNetworkHelper.shared.networkStatusChanged = { connected in
            label.text = connected ? "Connected" : "Disconnected"
        }
        window.addSubview(label)
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

