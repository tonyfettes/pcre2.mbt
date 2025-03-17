///|
fn main {
  try {
    let code = @pcre2.compile!("(?<hello>hell𐐷o)")
    let subject = "a hell𐐷o, 你好 𐐷 world! hell𐐷o"
    let match_ = code.matches!(subject)
    while match_.next!() is Some(match_) {
      for name, capture in match_.captures() {
        println("\{name}: \{capture.view()}")
      }
    }
  } catch {
    error => println("Error: \{error}")
  }
}
