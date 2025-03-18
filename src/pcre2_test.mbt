///|
test "captures" {
  let code = @pcre2.compile!("(?<hello>hell𐐷o)")
  let subject = "a hell𐐷o, 你好 𐐷 world! hell𐐷o"
  let match_ = code.matches!(subject)
  let views = []
  while match_.next!() is Some(match_) {
    for _, capture in match_.captures() {
      views.push(capture.view().to_string())
    }
  }
  @json.inspect!(views, content=[
    "hell𐐷o", "hell𐐷o", "hell𐐷o", "hell𐐷o",
  ])
}

///|
test "split" {
  let code = @pcre2.compile!(
    "'s|'t|'re|'ve|'m|'ll|'d| ?\\p{L}+| ?\\p{N}+| ?[^\\s\\p{L}\\p{N}]+|\\s+(?!\\S)|\\s+",
  )
  let subject = "He's a good person"
  let match_ = code.matches!(subject)
  while match_.next!() is Some(match_) {
    for _, capture in match_.captures() {
      println(capture.view())
    }
  }
}
