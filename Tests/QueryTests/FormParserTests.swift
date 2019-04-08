@testable import Query
import XCTest

final class FormParserTests: XCTestCase {
  func testKeyValuePair() {
    assertForm("foo=bar", ["foo": "bar"])
    assertForm("foo=", ["foo": ""])
    assertForm("foo", ["foo": nil])
    assertForm("foo=bar&hello=world", ["foo": "bar", "hello": "world"])
    assertForm("=bar", ["": "bar"])
    assertForm("", [:])
  }
}

func assertForm(
  _ query: String,
  _ expectedForm: Form,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) {
  var parser = FormParser(query: query)
  let form = parser.parseForm()
  XCTAssertEqual(form, expectedForm, message(), file: file, line: line)
}
