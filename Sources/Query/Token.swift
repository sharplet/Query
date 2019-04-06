enum Token: Hashable {
  case text(Substring)
  case separator(QuerySeparator)
  case end
}

extension Token: CustomStringConvertible {
  var description: String {
    switch self {
    case let .text(text):
      return "text(\(text))"
    case let .separator(separator):
      return "separator(\(separator))"
    case .end:
      return "end"
    }
  }
}
