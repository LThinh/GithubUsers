//
//  PublishRelayWrapper.swift
//  GithubUsersTests
//
//  Created by Thinh Le on 12/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

class PublishRelayWrapper<T> {
    private(set) var emitedValues = [T]()
    private let disposeBag = DisposeBag()
    
    init(_ instance: PublishRelay<T>) {
        instance
            .bind { [weak self] value in
                self?.emitedValues.append(value)
            }
            .disposed(by: disposeBag)
    }
    
    var value: T? {
        return emitedValues.last
    }
}
