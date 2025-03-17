///|
test {
  try {
    let code = @pcre2.compile("(?<hello>hell𐐷o)")
    let subject = "a hell𐐷o, 你好 𐐷 world! hell𐐷o"
    let match_ = code.match_string(subject)
    while match_.next!() is Some(match_) {
      for name, capture in match_.captures() {
        println("\{name}: \{capture.string_view()}")
      }
    }
    println("")
  } catch {
    error => println("Error: \{error}")
  }
}
