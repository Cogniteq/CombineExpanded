import Combine
import Foundation

public extension Publisher {
    func then<NextPublisher: Publisher>(_ nextPublisher: NextPublisher) -> AnyPublisher<NextPublisher.Output, NextPublisher.Failure> where Failure == NextPublisher.Failure {
        ignoreOutput()
            .map { _ -> NextPublisher.Output in }
            .append(nextPublisher)
            .eraseToAnyPublisher()
    }
}
