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

    func testIgnoreSelfValues() {
        var cancellables = Set<AnyCancellable>()
        var values = [Int]()

        let publisher1 = Future<Int, Never>.deferred { future in
            future(.success(1))
        }

        let publisher2 = Future<Int, Never>.deferred { future in
            future(.success(2))
        }

        publisher1.then(publisher2)
            .sink {
                values.append($0)
            }
            .store(in: &cancellables)

        XCTAssertTrue(values.count == 1)
        XCTAssertTrue(values[0] == 2)
    }
}
