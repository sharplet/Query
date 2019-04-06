struct Tokenizer: IteratorProtocol {
  private enum Separator: Character {
    case field = "&"
    case value = "="
  }

  private enum State {
    case initial
    case name
    case separator(Separator)
    case value
    case finished
  }

  let string: String
  private var remaining: Substring
  private var state: State

  init(string: String) {
    self.remaining = string[...]
    self.state = .initial
    self.string = string
  }

  mutating func next() -> Token? {
    switch state {
    case .finished:
      return nil

    case _ where remaining.isEmpty:
      state = .finished
      return .end

    case .initial:
      if remaining.first == Separator.field.rawValue {
        state = .separator(.field)
      } else {
        state = .name
      }

      return next()

    case .name:
      let (separator, name) = remaining.eat(upTo: Separator.self)
      if let separator = separator {
        state = .separator(separator)
      }
      return .name(name)

    case let .separator(separator):
      switch separator {
      case .field:
        state = .initial
      case .value:
        state = .value
      }

      return .separator(remaining.eat(asserting: separator.rawValue))

    case .value:
      let value = remaining.eat(upTo: Separator.field.rawValue)
      if !remaining.isEmpty {
        state = .separator(.field)
      }
      return .value(value)
    }
  }
}
