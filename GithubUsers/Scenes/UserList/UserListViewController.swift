//
//  
//  UserListViewController.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//
//
import UIKit

final class UserListViewController: BaseViewController {
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    private let refreshControl = UIRefreshControl()
    private var userDetailFactory: ((String) -> UIViewController)!
    
    // MARK: - View Model
    private var viewModel: UserListViewModel!
    
    // MARK: - Init
    convenience init(
        viewModel: UserListViewModel,
        userDetailFactory: @escaping ((String) -> UIViewController)) {
        self.init()
        self.userDetailFactory = userDetailFactory
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
        title = "User List"
        
        let leftIcon = UIImage(named: "burger_icon")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftIcon, style: .plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(GithubUserCell.self)
        tableView.addSubview(refreshControl)
        
        tableView.rx.modelSelected(GithubUser.self)
            .bind { [weak self] user in
                guard let self = self else { return }
                let viewController = self.userDetailFactory(user.username)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupBinding() {
        // Input
        viewModel.viewIsReady.accept(())
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshTrigger)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.pageLoading
            .bind(to: rx.isLoading)
            .disposed(by: disposeBag)
        
        viewModel.refreshLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.listUser
            .bind(to: tableView.rx.items) { tableView, row, user in
                let cell = tableView.dequeueReusableCell(
                    GithubUserCell.self,
                    for: IndexPath(row: row, section: 0))
                cell.setupUI(using: user)
                return cell
            }
            .disposed(by: disposeBag)
    }
}
