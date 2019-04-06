struct Tokenizer: IteratorProtocol {
  let string: String
  private var isFinished: Bool
  private var skipValueSeparator: Bool
  private var remaining: Substring

  init(string: String) {
    self.isFinished = false
    self.remaining = string[...]
    self.skipValueSeparator = false
    self.string = string
  }

  mutating func next() -> Token? {
    guard !isFinished else { return nil }

    guard !remaining.isEmpty else {
      isFinished = true
      return .end
    }

    switch remaining.first! {
    case "=" where !skipValueSeparator:
      skipValueSeparator = true
      fallthrough
    case "&":
      let separator = QuerySeparator(rawValue: remaining.eat())!
      return .separator(separator)

    default:
      let text: Substring

      if skipValueSeparator {
        skipValueSeparator = false
        text = remaining.eat(upTo: "&")
      } else {
        text = remaining.eat(upToOneOf: QuerySeparator.allowedCharacters)
      }

      return .text(text)
    }
  }
}
