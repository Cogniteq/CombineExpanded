import Combine
import Foundation

public extension Future {
    static func deferred(_ attemptToFulfill: @escaping (@escaping Future<Output, Failure>.Promise) -> Void) -> AnyPublisher<Output, Failure> {
        Deferred {
            Future<Output, Failure> { future in
                attemptToFulfill(future)
            }
        }.eraseToAnyPublisher()
    }
}
