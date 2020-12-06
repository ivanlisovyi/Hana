import XCTest
import NingTestingSupport

@testable import Kaori

final class KaoriTests: XCTestCase {
  func testsPosts() throws {
    // Given
    let sut = Kaori.live

    // When
    let posts = try awaitCompletion(of: sut.posts())

    // The
    XCTAssertTrue(posts.count > 0)
  }
}
