@testable import Query
import XCTest

final class TokenizerTests: XCTestCase {
  func testTokenizer() {
    assertTokens("foo", [.name("foo")])
    assertTokens("foo=bar", [.name("foo"), .separator("="), .value("bar")])
    assertTokens("foo%3Dbar", [.name("foo%3Dbar")])
    assertTokens("foo==bar", [.name("foo"), .separator("="), .value("=bar")])
    assertTokens("&foo=bar", [.separator("&"), .name("foo"), .separator("="), .value("bar")])
    assertTokens("foo=bar&", [.name("foo"), .separator("="), .value("bar"), .separator("&")])
    assertTokens("foo&bar=", [.name("foo"), .separator("&"), .name("bar"), .separator("=")])
    assertTokens("foo&&bar", [.name("foo"), .separator("&"), .separator("&"), .name("bar")])
  }

  func testSubstringHash() {
    let source = "foofoo"
    let midpoint = source.lastIndex(of: "f")!
    XCTAssertEqual(source[..<midpoint],           source[midpoint...])
    XCTAssertEqual(source[..<midpoint].hashValue, source[midpoint...].hashValue)
  }
}

func assertTokens(_ query: String, _ expectedTokens: [Token], file: StaticString = #file, line: UInt = #line) {
  let tokenizer = Tokenizer(string: query)
  let tokens = Array(IteratorSequence(tokenizer))
  XCTAssertEqual(tokens, expectedTokens, file: file, line: line)
}
