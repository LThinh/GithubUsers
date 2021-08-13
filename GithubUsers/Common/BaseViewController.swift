//
//  BaseViewController.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import UIKit
import RxSwift

/// Base view controller for all view controller in the app.
public class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    deinit {
        dump("Deinit: \(Self.self)")
    }
    
    private lazy var activityIndicatorView = UIActivityIndicatorView()
    
    func showActivityIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
}

// MARK: - Show Error Message
extension Reactive where Base: BaseViewController {
    // Reactive wrapper for showing error message alert on topViewController
    var showErrorMessage: Binder<String> {
        return Binder(base) { _, message in
            let topViewController = UIApplication.shared.topViewController
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            topViewController?.present(alert, animated: true)
        }
    }
}

// MARK: - Show Loading
extension Reactive where Base: BaseViewController {
    // Reactive wrapper for showing error message alert on topViewController
    var isLoading: Binder<Bool> {
        return Binder(base) { viewController, loading in
            if loading {
                viewController.showActivityIndicator()
            } else {
                viewController.hideActivityIndicator()
            }
        }
    }
}
