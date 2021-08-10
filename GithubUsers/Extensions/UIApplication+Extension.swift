//
//  UIApplication+Extension.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import UIKit

extension UIApplication {
    var topViewController: UIViewController? {
        if windows.first(where: { $0.isKeyWindow })?.rootViewController == nil {
            return nil
        }
        
        var topViewController = windows.first(where: { $0.isKeyWindow })?.rootViewController
        
        while  topViewController?.presentedViewController != nil {
            switch topViewController?.presentedViewController {
            case let navagationController as UINavigationController:
                topViewController = navagationController.viewControllers.last
            case let tabBarController as UITabBarController:
                topViewController = tabBarController.selectedViewController
            default:
                topViewController = topViewController?.presentedViewController
            }
        }
        return topViewController
        
    }
}
