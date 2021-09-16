import Combine
@testable import CombineExpanded
import XCTest

final class FutureDeferredTests: XCTestCase {
    private var cancellable: Set<AnyCancellable> = .init()

    func testDoNotStartDeferredAfterInit() throws {
        var count = 0
        _ = Future<Void, Error>.deferred { future in
            count += 1
            future(.success(()))
        }

        XCTAssertTrue(count == 0)
    }

    func testStartDeferredAfterSubscription() throws {
        var count = 0
        let future = Future<Void, Error>.deferred { future in
            count += 1
            future(.success(()))
        }
        future.sink(receiveCompletion: { _ in }, receiveValue: { _ in }).store(in: &cancellable)

        XCTAssertTrue(count == 1)
    }

    func testStartFutureAfterInit() throws {
        var count = 0
        _ = Future<Void, Error> { future in
            count += 1
            future(.success(()))
        }

        XCTAssertTrue(count == 1)
    }
}
