import Combine
@testable import CombineExpanded
import XCTest

final class CombineThenTests: XCTestCase {
    func testStartNextAfterSelf() {
        var cancellables = Set<AnyCancellable>()
        var publisher1Completed = false
        var publisher2Completed = false

        let publisher1 = Future<Void, Never>.deferred { future in
            future(.success(()))
        }.handleEvents(receiveCompletion: { _ in
            publisher1Completed = true
        })

        let publisher2 = Future<Void, Never>.deferred { future in
            XCTAssertTrue(publisher1Completed)
            future(.success(()))
        }.handleEvents(receiveCompletion: { _ in
            publisher2Completed = true
        })

        publisher1.then(publisher2)
            .sink {}
            .store(in: &cancellables)
        
        XCTAssertTrue(publisher2Completed)
    }
}
