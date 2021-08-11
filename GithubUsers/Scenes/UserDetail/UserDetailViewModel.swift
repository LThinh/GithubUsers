//
//  
//  UserDetailViewModel.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//
//
import Foundation
import RxSwift
import RxCocoa

class UserDetailViewModel {
    private let disposeBag = DisposeBag()
    private let service: UserDetailService
    private let username: String
    
    // Intput
    let viewIsReady = PublishRelay<Void>()
    let refreshTrigger = PublishRelay<Void>()
    
    // Output
    let user = PublishRelay<GithubUser>()
    let pageLoading = BehaviorRelay<Bool>(value: false)
    let refreshLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    // MARK: - Init
    init(username: String, service: UserDetailService) {
        self.service = service
        self.username = username
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
            .bind(to: user)
            .disposed(by: disposeBag)
        
        Observable.merge(
            viewIsReady.mapToTrue(),
            activityIndicator.asObservable().mapToFalse()
        )
        .bind(to: pageLoading)
        .disposed(by: disposeBag)
        
        Observable.merge(
            refreshTrigger.mapToTrue(),
            activityIndicator.asObservable().mapToFalse()
        )
        .bind(to: refreshLoading)
        .disposed(by: disposeBag)
    }
    
    private func getListUser() -> Observable<GithubUser> {
        Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            self.service.getUserDetail(username: self.username) { result in
                switch result {
                case .failure(let error):
                    self.errorMessage.accept(error.localizedDescription)
                    observer.onCompleted()
                case .success(let user):
                    observer.onNext(user)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
