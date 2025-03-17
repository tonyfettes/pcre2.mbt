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
  code.free()
  @json.inspect!(views, content=["hell𐐷o", "hell𐐷o"])
}
