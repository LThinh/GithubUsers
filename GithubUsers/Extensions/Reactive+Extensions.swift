//
//  Reactive+Extensions.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation
import RxCocoa
import RxSwift

public extension ObservableType {
    func catchErrorJustComplete() -> Observable<Element> {
        return self.catch { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    
    func asDriverOnErrorJustNever() -> Driver<Element> {
        return asDriver { _ in
            return Driver.never()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func mapToTrue() -> Observable<Bool> {
        return map { _ in true}
    }
    
    func mapToFalse() -> Observable<Bool> {
        return map { _ in false}
    }
    
    func map<T>(to this: T) -> Observable<T> {
        return map { _ in this}
    }
}

// MARK: - ActivityIndicator
class ActivityIndicator: SharedSequenceConvertibleType {
    typealias Element = Bool
    typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _behavior = BehaviorRelay<Bool>(value: false)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    
    init() {
        _loading = _behavior.asDriver()
            .distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(
        _ source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }
    
    private func subscribed() {
        _lock.lock()
        _behavior.accept(true)
        _lock.unlock()
    }
    
    private func sendStopLoading() {
        _lock.lock()
        _behavior.accept(false)
        _lock.unlock()
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
    
    var isLoading: Bool {
        _behavior.value
    }
}

extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}

// MARK: - ErrorTracker
final class ErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    
    private let _subject = PublishSubject<Swift.Error>()
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, Swift.Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }
    
    func asObservable() -> Observable<Swift.Error> {
        return _subject.asObservable()
    }
    
    func asDriver() -> Driver<Swift.Error> {
        return _subject.asDriverOnErrorJustComplete()
    }
    
    private func onError(_ error: Swift.Error) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
