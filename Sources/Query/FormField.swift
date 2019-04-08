public struct FormField {
  public var name: String
  public var value: String?

  public init(name: String, value: String?) {
    self.name = name
    self.value = value
  }
}

extension FormField {
  init<Name: StringProtocol>(name: Name, value: String?) {
    self.name = String(name)
    self.value = value
  }

  init<Name: StringProtocol, Value: StringProtocol>(name: Name, value: Value?) {
    self.name = String(name)
    self.value = value.map { String($0) }
  }
}

extension FormField: Hashable {}

extension FormField: CustomStringConvertible {
  public var description: String {
    var description = name
    if let value = value {
      description += "=\(value)"
    }
    return description
  }
}
