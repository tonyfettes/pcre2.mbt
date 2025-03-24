///|
fn main {
  try {
    let code = @pcre2.compile!("(?<hello>hell𐐷o)")
    let subject = "a hell𐐷o, 你好 𐐷 world! hell𐐷o"
    for match_ in code.matches!(subject) {
      let match_ = match_.unwrap_or_error!()
      for name, capture in match_.named_groups() {
        println("\{name}: \{capture}")
      }
    }
  } catch {
    error => println("Error: \{error}")
  }
}
