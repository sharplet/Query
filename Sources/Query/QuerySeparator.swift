enum QuerySeparator: Character {
  case field = "&"
  case value = "="

  static let allowedCharacters = Set("&=")
}
