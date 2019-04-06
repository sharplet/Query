extension Substring {
  mutating func eat() -> Character {
    return removeFirst()
  }

  mutating func eat(asserting expectedCharacter: Character) -> Character {
    let character = removeFirst()
    assert(character == expectedCharacter)
    return character
  }

  mutating func eat(upTo character: Character) -> Substring {
    return eat(until: { $0 == character })
  }

  mutating func eat(upToOneOf excludedCharacters: Set<Character>) -> Substring {
    return eat(until: excludedCharacters.contains)
  }

  mutating func eat(until isNotIncluded: (Character) -> Bool) -> Substring {
    if let index = firstIndex(where: isNotIncluded) {
      defer { self = self[index...] }
      return self[..<index]
    } else {
      defer { self.removeAll() }
      return self[...]
    }
  }
}
