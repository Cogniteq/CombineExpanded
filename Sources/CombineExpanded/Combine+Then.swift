import Combine
import Foundation

public extension Publisher {

    /// Wait for completion of `self`, *then* forward all events from `next`. All values sent from `self` are ignored.
    /// - Parameter nextPublisher: A producer to start when `self` completes.
    /// - Returns: A producer that sends events from `self` and then from `nextPublisher` when `self` completes.
    func then<NextPublisher: Publisher>(_ nextPublisher: NextPublisher) -> AnyPublisher<NextPublisher.Output, NextPublisher.Failure> where Failure == NextPublisher.Failure {
        ignoreOutput()
            .map { _ -> NextPublisher.Output in }
            .append(nextPublisher)
            .eraseToAnyPublisher()
    }
}
