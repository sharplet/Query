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
    case _ where remaining.isEmpty, .finished:
      return nil

    case .initial:
      if remaining.first == Separator.field.rawValue {
        state = .separator(.field)
      } else {
        state = .name
      }

      return next()

    case .name:
      let (separator, name) = remaining.eat(upTo: Separator.self)
      state = separator.map(State.separator) ?? .finished
      return .name(name)

    case let .separator(separator):
      switch separator {
      case .field:
        state = .name
      case .value:
        state = .value
      }

      return .separator(remaining.eat(asserting: separator.rawValue))

    case .value:
      let value = remaining.eat(upTo: Separator.field.rawValue)
      state = remaining.isEmpty ? .finished : .separator(.field)
      return .value(value)
    }
  }
}
