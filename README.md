# Query

Encode and decode query strings.

## To Do

- [ ] Unescape field names and values
- [ ] Support decoding from String and Data (any collection of ASCII code units)
- [ ] Parse token stream into an AST for building structured data
- [ ] Add Decoder implementation that uses the AST to support decoding Swift types
- [ ] Encode structured and unstructured form data according to the `application/x-www-form-urlencoded` media type.

## Not To Do

  - **Trim leading and trailing whitespace**

    See [commit 443736a7d579da8aa03ce14d17ebdf100e0a08b3][trim-commit]. Decided
    to preserve whitespace instead of trimming it.

  - **No invalid characters in input**

    Following the [robustness principle][], decided that validating input
    beyond the documented use of reserved characters isn't desirable. Instead,
    we'll be very conservative on the encoding end to ensure outgoing data is
    only printable ASCII.

[robustness principle]: https://en.wikipedia.org/wiki/Robustness_principle
[trim-commit]: https://github.com/sharplet/Query/commit/443736a7d579da8aa03ce14d17ebdf100e0a08b3
