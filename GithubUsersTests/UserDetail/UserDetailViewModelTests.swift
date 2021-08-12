//
//  UserDetailViewModelTests.swift
//  GithubUsersTests
//
//  Created by Thinh Le on 11/08/2021.
//

import XCTest
@testable import GithubUsers

class UserDetailViewModelTests: XCTestCase {
    func test_fetchUserDetailById_returnCorrectData() {
        let sut = makeSut(username: "2")
        let response: Result<GithubUser, Failure> = .success(getMockUser())
        UserDetailServiceMock.response = response
        let output = PublishRelayWrapper(sut.user)
        
        sut.viewIsReady.accept(())
        wait(0.1)
        
        XCTAssertNotNil(output.value)
        XCTAssertTrue(output.value?.followers == 4)
        XCTAssertTrue(output.value?.name == "hello")
    }
}
