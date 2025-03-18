///|
test "captures" {
  let code = @pcre2.compile!("(?<hello>hello)")
  let subject = "a hello, 你好  world! hello"
  let views = []
  for match_ in code.matches!(subject) {
    for _, capture in match_.named_groups() {
      views.push(capture.to_string())
    }
  }
  @json.inspect!(views, content=["hello", "hello"])
}

///|
test "split" {
  let code = @pcre2.compile!(
    "'s|'t|'re|'ve|'m|'ll|'d| ?\\p{L}+| ?\\p{N}+| ?[^\\s\\p{L}\\p{N}]+|\\s+(?!\\S)|\\s+",
  )
  let subject = "He's a good person"
  let splits = []
  for match_ in code.matches!(subject) {
    for _, capture in match_.groups() {
      splits.push(capture.to_string())
    }
  }
  @json.inspect!(splits, content=["He", "'s", " a", " good", " person"])
}
