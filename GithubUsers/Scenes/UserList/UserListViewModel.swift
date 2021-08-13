//
//  
//  UserListViewModel.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//
//
import Foundation
import RxSwift
import RxCocoa

final class UserListViewModel {
    private let disposeBag = DisposeBag()
    private let service: UserListService
    
    // Intput
    let viewIsReady = PublishRelay<Void>()
    let refreshTrigger = PublishRelay<Void>()
    
    // Output
    let listUser = BehaviorRelay<[GithubUser]>(value: [])
    let pageLoading = BehaviorRelay<Bool>(value: false)
    let refreshLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    // MARK: - Init
    init(service: UserListService) {
        self.service = service
        setupBinding()
    }
    
    // MARK: - Private functions
    private func setupBinding() {
        let activityIndicator = ActivityIndicator()
        
        let requestTrigger = Observable.merge(
            viewIsReady.asObservable(),
            refreshTrigger.asObservable())
        
        requestTrigger
            .flatMapLatest({ [unowned self] in
                return getListUser()
                    .trackActivity(activityIndicator)
            })
            .bind(to: listUser)
            .disposed(by: disposeBag)
        
        Observable.merge(
            viewIsReady.mapToTrue(),
            activityIndicator.asObservable().filter({ !$0 })
        )
        .bind(to: pageLoading)
        .disposed(by: disposeBag)
        
        Observable.merge(
            refreshTrigger.mapToTrue(),
            activityIndicator.asObservable().filter({ !$0 })
        )
        .bind(to: refreshLoading)
        .disposed(by: disposeBag)
    }
    
    private func getListUser() -> Observable<[GithubUser]> {
        Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            self.service.getListUser { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.errorMessage.accept(error.localizedDescription)
                    observer.onCompleted()
                case .success(let users):
                    observer.onNext(users)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
