import Combine
import Foundation

public extension Future {

    /// Delays `Future` start until it is subscribed.
    /// - Parameter attemptToFulfill: Closure that creates new publisher.
    /// - Returns: A producer that is started after subscription.
    static func deferred(_ attemptToFulfill: @escaping (@escaping Future<Output, Failure>.Promise) -> Void) -> AnyPublisher<Output, Failure> {
        Deferred {
            Future<Output, Failure> { future in
                attemptToFulfill(future)
            }
        }.eraseToAnyPublisher()
    }
}
