public struct Form {
  public var fields: [FormField]
}

extension Form: Equatable {}

extension Form: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (String, String?)...) {
    self.fields = elements.map(FormField.init)
  }
}
