import XCTest
@testable import Posts

final class PostsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Posts().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
