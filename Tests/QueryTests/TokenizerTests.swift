@testable import Query
import XCTest

final class TokenizerTests: XCTestCase {
  func testTokenizer() {
    assertTokens("foo", [.text("foo"), .end])
    assertTokens("foo=bar", [.text("foo"), .separator(.value), .text("bar"), .end])
    assertTokens("foo%3Dbar", [.text("foo%3Dbar"), .end])
    assertTokens("foo==bar", [.text("foo"), .separator(.value), .text("=bar"), .end])
    assertTokens("&foo=bar", [.separator(.field), .text("foo"), .separator(.value), .text("bar"), .end])
    assertTokens("foo=bar&", [.text("foo"), .separator(.value), .text("bar"), .separator(.field), .end])
    assertTokens("foo&bar=", [.text("foo"), .separator(.field), .text("bar"), .separator(.value), .end])
    assertTokens("foo&&bar", [.text("foo"), .separator(.field), .separator(.field), .text("bar"), .end])
    assertTokens("foo=bar=baz", [.text("foo"), .separator(.value), .text("bar=baz"), .end])
    assertTokens(" foo= bar ", [.text(" foo"), .separator(.value), .text(" bar "), .end])
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
