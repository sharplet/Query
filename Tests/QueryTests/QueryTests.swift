@testable import Query
import XCTest

final class QueryTests: XCTestCase {
  func testExample() {
    XCTAssertEqual(Query().text, "Hello, World!")
  }
}
