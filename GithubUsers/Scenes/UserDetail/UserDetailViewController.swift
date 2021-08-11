//
//  
//  UserDetailViewController.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//
//
import UIKit
import RxCocoa
import RxSwift

class UserDetailViewController: BaseViewController {
    // MARK: - Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var repoLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    // MARK: - View Model
    private var viewModel: UserDetailViewModel!
    
    // MARK: - Property
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Init
    convenience init(viewModel: UserDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    // MARK: - Private functions
    private func setupUI() {
        title = "Profile"
        scrollView.addSubview(refreshControl)
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }
    
    private func setupBinding() {
        // Input
        viewModel.viewIsReady.accept(())
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshTrigger)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.user
            .bind(to: rx.user)
            .disposed(by: disposeBag)
        
        viewModel.pageLoading
            .bind(to: rx.isLoading)
            .disposed(by: disposeBag)
        
        viewModel.refreshLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .bind(to: rx.showErrorMessage)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: UserDetailViewController {
    var user: Binder<GithubUser> {
        return Binder(base) { view, user in
            view.avatarImageView.setImage(from: user.avatarUrl)
            view.usernameLabel.text = user.username
            view.locationLabel.text = user.location
            view.bioLabel.text = user.bio
            view.repoLabel.text = "\(user.publicRepos ?? 0)"
            view.followersLabel.text = "\(user.followers ?? 0)"
            view.followingLabel.text = "\(user.following ?? 0)"
        }
    }
}
