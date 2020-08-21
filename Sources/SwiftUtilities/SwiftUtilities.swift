import Combine
import Foundation

/// A publisher that immediately throws
/// - Parameters:
///   - type: The expected type of the publisher
///   - error: The error to throw
/// - Returns: AnyPublisher<Type, Error> That fails immediately
///
/// -- Use case
/// Sometimes a function returns a publisher, but we need to unwap a value or perform a try catch before a publisher can be created. In this instance we can return this publisher instead to allow the publisher chain to handle those errors.
public func ThrowingPublisher<T>(forType type: T.Type, throws error: Error) -> AnyPublisher<T, Error> {
    Result<T?, Error> { nil }
        .publisher
        .eraseToAnyPublisher()
        .tryMap {
            guard let value = $0 else {
                throw error
            }
            return value
        }.eraseToAnyPublisher()
}


infix operator ??? : TernaryPrecedence
/// Unwrap or throw
/// - Parameters:
///   - left: Any Optional
///   - right: Error
/// - Throws: The error from the right
/// - Returns: The unwrapped optional from the left
///
/// ```swift
///     var x: Int? = nil
///     let y = try x ??? SomeError() // Throws some Error
///
///     var value: Int? = 1
///     let z = try value ??? SomeError() // unwraps value
/// ```
///
public func ???<T>(_ left: Optional<T>, right: Error) throws -> T {
    guard let value = left else { throw right }
    return value
}


public func onMain(_ execute: @escaping () -> Void) {
    DispatchQueue.main.async { execute() }
}


public extension Decimal {
    func dollarFormat() -> String {
        return isPositive() ? toDollarsAndCents() : (-self).toDollarsAndCents()
    }
}


fileprivate extension Decimal {
    func toDollarsAndCents() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
    }

    func isPositive() -> Bool {
        return self >= 0.0
    }

}


public extension Publisher {
    func eraseToEmptyPublisher() -> AnyPublisher<Void, Failure> {
        map { _ in return }.eraseToAnyPublisher()
    }
}


public extension Optional {
    func unwrapToPublisher(orThrow error: Error) -> AnyPublisher<Wrapped, Error> {
        Just(self)
            .tryMap { try $0 ??? error }
            .eraseToAnyPublisher()
    }
}
