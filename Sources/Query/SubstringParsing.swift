extension Substring {
  mutating func eat(asserting expectedCharacter: Character) -> Character {
    let character = removeFirst()
    assert(character == expectedCharacter)
    return character
  }

  mutating func eat(upTo character: Character) -> Substring {
    if let index = firstIndex(of: character) {
      defer { self = self[index...] }
      return self[..<index]
    } else {
      defer { self.removeAll() }
      return self[...]
    }
  }

  mutating func eat<Value: RawRepresentable>(upTo _: Value.Type) -> (Value?, Substring) where Value.RawValue == Character {
    var i = startIndex
    defer { self = self[i...] }

    var result: Value?

    scanning: while i < endIndex {
      if let value = Value(rawValue: self[i]) {
        result = value
        break scanning
      }

      formIndex(after: &i)
    }

    return (result, self[..<i])
  }
}
