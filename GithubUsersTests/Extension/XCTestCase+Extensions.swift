//
//  XCTestCase+Extensions.swift
//  GithubUsersTests
//
//  Created by Thinh Le on 12/08/2021.
//

import XCTest

extension XCTestCase {
  func wait(_ second: Double) {
    let expectation = DelayExpectation(second)
    wait(for: [expectation], timeout: second + 0.1)
  }
}

fileprivate class DelayExpectation: XCTestExpectation {
  private let delay: Double

  init(_ delay: Double) {
    self.delay = delay
    super.init(description: "")
    start()
  }

  func start() {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
      self?.fulfill()
    }
  }
}
