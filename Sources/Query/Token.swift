enum Token: Hashable {
  case name(Substring)
  case value(Substring)
  case separator(Character)
  case end
}

extension Token: CustomStringConvertible {
  var description: String {
    switch self {
    case let .name(name):
      return "name(\(name))"
    case let .value(value):
      return "value(\(value))"
    case let .separator(separator):
      return "separator(\(separator))"
    case .end:
      return "end"
    }
  }
}
