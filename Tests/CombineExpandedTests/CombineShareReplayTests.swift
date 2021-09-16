import Combine
@testable import CombineExpanded
import XCTest

final class CombineShareReplayTests: XCTestCase {
    func testStartOnce() {
        var cancellables = Set<AnyCancellable>()
        var startCounter = 0
        let publisher = Future<Void, Never>.deferred { future in
            startCounter += 1
            future(.success(()))
        }.shareReplay(1)

        publisher
            .sink {}
            .store(in: &cancellables)

        publisher
            .sink {}
            .store(in: &cancellables)

        XCTAssertTrue(startCounter == 1)
    }

    func testCompleteAll() {
        var cancellables = Set<AnyCancellable>()
        let publisher = Future<Void, Never>.deferred { future in
            future(.success(()))
        }.shareReplay(1)

        let expectation1 = expectation(description: "subscription 1")
        let expectation2 = expectation(description: "subscription 2")

        publisher
            .sink(receiveCompletion: { _ in
                expectation1.fulfill()
            }, receiveValue: {})
            .store(in: &cancellables)

        publisher
            .sink(receiveCompletion: { _ in
                expectation2.fulfill()
            }, receiveValue: {})
            .store(in: &cancellables)

        wait(for: [expectation1, expectation2], timeout: 0.1)
    }
}
