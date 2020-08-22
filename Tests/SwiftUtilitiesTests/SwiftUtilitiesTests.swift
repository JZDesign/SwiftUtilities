import XCTest
import Combine
import Foundation
@testable import SwiftUtilities

class UtilityTests: XCTestCase {

    func testDollarFormat() {
        let values = [(120.0, "$120.00"),
                      (0.0, "$0.00"),
                      (0.1433, "$0.14"),
                      (0.001, "$0.00"),
                      (-0.001, "$0.00"),
                      (0.009, "$0.01"),
                      (-120.0, "$120.00")]
        for (value, stringValue) in values {
            XCTAssertEqual(Decimal(value).dollarFormat(), stringValue)
        }
    }


    func testOptionalPublisherThrows() {
        let optional: Int? = nil

        optional.unwrapToPublisher(orThrow: SomeError())
            .assertError(test: self) {
                XCTAssertNotNil($0 as? SomeError)
            }
    }

    func testOptionalPublisherUnwraps() {
        let optional: Int? = 1

        optional.unwrapToPublisher(orThrow: SomeError())
            .assertResult(test: self) {
                XCTAssertEqual(1, $0)
        }
    }

    struct SomeError: Error {}
    
    func testUnwrapOrThrowThrows() {
        let someNum: Int? = nil
        Just(someNum)
            .tryMap { try $0 ??? SomeError() }
            .eraseToAnyPublisher()
            .assertError(test: self) { error in
                XCTAssertEqual(
                    error.localizedDescription,
                    SomeError().localizedDescription
                )
            }

    }


    func testUnwrapOrThrowUnwraps() {
        let someNum: Int? = 1
        Just(someNum)
            .tryMap { try $0 ??? SomeError() }
            .eraseToAnyPublisher()
            .assertResult(test: self) {
                XCTAssertEqual($0, 1)
        }
    }
    
}

struct TestJSON: Decodable, Equatable {
    let test: String
}
