struct FormParser {
  private enum State {
    case initial
    case name(Substring)
    case value(fieldName: Substring)
    case field(FormField)
  }

  let query: String
  private var state: State
  private var tokenizer: Tokenizer

  init(query: String) {
    self.query = query
    self.state = .initial
    self.tokenizer = Tokenizer(string: query)
  }

  // swiftlint:disable:next cyclomatic_complexity
  mutating func parseForm() -> Form {
    var fields: [FormField] = []

    parsing: while let token = tokenizer.next() {
      switch (state, token) {
      case let (.initial, .text(text)):
        state = .name(text)
      case (.initial, .separator(.value)):
        state = .value(fieldName: "")

      case (.initial, .separator(.field)):
        continue parsing
      case (.initial, .end):
        break parsing

      case let (.name(name), .separator(.value)):
        state = .value(fieldName: name)

      case let (.name(name), .separator(.field)),
           let (.name(name), .end):
        let field = FormField(name: name, value: nil)
        fields.append(field)
        state = .initial

      case (var .name(name), let .text(text)):
        // The tokenizer should never produce multiple text tokens for the same
        // field without a value separator. If this state somehow occurs, just
        // concatenate the new text to the existing name. This will trigger an
        // unexpected copy and invalidate the substring indices, which is not
        // ideal, but it will preserve the source data.
        assertionFailure("Unexpected value text without value separator")
        name.append(contentsOf: text)
        state = .name(name)
        continue parsing

      case let (.value(fieldName), .text(value)):
        let field = FormField(name: fieldName, value: value)
        state = .field(field)

      case let (.value(fieldName), .separator(.field)),
           let (.value(fieldName), .end):
        let field = FormField(name: fieldName, value: "")
        fields.append(field)
        state = .initial

      case (.value, .separator(.value)),
           (.field, .separator(.value)):
        // We should never see multiple value separators within a single field,
        // but if we do we can just ignore the separator and continue parsing.
        assertionFailure("Multiple value separators in a single field")
        continue parsing

      case let (.field(field), .separator(.field)),
           let (.field(field), .end):
        fields.append(field)
        state = .initial

      case (var .field(field), let .text(text)):
        // We should never see multiple text tokens after a value separator,
        // but like in the case of multiple text tokens before the value
        // separator, we'll preserve user data by appending the new text to the
        // existing value, or replacing it.
        assertionFailure("Unexpected text after field value")
        if var value = field.value {
          value.append(contentsOf: text)
          field.value = value
        } else {
          field.value = String(text)
        }
      }
    }

    return Form(fields: fields)
  }
}
