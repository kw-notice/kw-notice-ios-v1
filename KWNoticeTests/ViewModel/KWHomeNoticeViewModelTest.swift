//
//  KWHomeNoticeViewModelTest.swift
//  KWNoticeTests
//
//  Created by 김세영 on 2022/07/05.
//

import XCTest
import KWNoticeKit
import Combine
@testable import KWNotice

class KWHomeNoticeViewModelTest_SucceedCase: XCTestCase {
    
    var viewModel: KWHomeNoticeViewModel!
    var titles = [String]()
    var searchTitle = ""
    var searchTargetCount = 0
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() async throws {
        searchTitle = .random(3)
        for i in 100...1000 {
            titles.append(i % 3 == 0 ? searchTitle + .random(100) : .random(100))
            if i % 3 == 0 { searchTargetCount += 1 }
        }
        
        DependencyContainer.shared.register(type: KWHomeRepositoryProtocol.self) { _ in
            KWHomeRepository(dataStore: TestKWHomeDataStore(self.titles, isSucceedCase: true))
        }
        viewModel = KWHomeNoticeViewModel()
    }
    
    func test_KWHomeViewModel_fetch_shouldSetNoticesPublisherByGivenNotices() async {
        // Given
        let expectation = XCTestExpectation(description: #function)
        
        // When
        var notices = [KWHomeNotice]()
        viewModel.$notices
            .sink(receiveValue: { receivedNotices in
                notices = receivedNotices
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        await viewModel.fetch()
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(titles, notices.map { $0.title })
    }
    
    func test_KWHomeViewModel_search_shouldSetNoticesPublisherByGivenNoticesContainSearchTitle() async {
        // Given
        let expectation = XCTestExpectation(description: #function)
        await viewModel.fetch()
        
        // When
        var notices = [KWHomeNotice]()
        viewModel.$notices
            .sink(receiveValue: { receivedNotices in
                notices = receivedNotices
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.search(text: searchTitle)
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertGreaterThanOrEqual(notices.count, searchTargetCount)
    }
}

class KWHomeNoticeViewModelTest_FailCase: XCTestCase {
    
    
    var viewModel: KWHomeNoticeViewModel!
    var titles = [String]()
    var searchTitle = ""
    var searchTargetCount = 0
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() async throws {
        searchTitle = .random(3)
        for i in 100...1000 {
            titles.append(i % 3 == 0 ? searchTitle + .random(100) : .random(100))
            if i % 3 == 0 { searchTargetCount += 1 }
        }
        
        DependencyContainer.shared.register(type: KWHomeRepositoryProtocol.self) { _ in
            KWHomeRepository(dataStore: TestKWHomeDataStore(self.titles, isSucceedCase: false))
        }
        viewModel = KWHomeNoticeViewModel()
    }
    
    func test_KWHomeNoticeViewModel_fetch_shouldPublishAlert() async {
        // Given
        let expectation = XCTestExpectation(description: #function)
        
        // When
        var alertMessage: String = ""
        viewModel.$alertMessage
            .sink(receiveValue: { receivedAlertMessage in
                alertMessage = receivedAlertMessage
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        await viewModel.fetch()
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(alertMessage.isEmpty)
    }
}
