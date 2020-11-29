import XCTest
@testable import Kaori

final class KaoriTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Kaori().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
