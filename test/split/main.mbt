///|
fn main {
  try {
    let code = @pcre2.compile!(
      "'s|'t|'re|'ve|'m|'ll|'d| ?\\p{L}+| ?\\p{N}+| ?[^\\s\\p{L}\\p{N}]+|\\s+(?!\\S)|\\s+",
    )
    let subject = "he's a good person. I've meet him and had a good time. I'm sure he'll be happy. I'd like to meet him again."
    for match_ in code.matches!(subject) {
      let match_ = match_.unwrap_or_error!()
      for _, group in match_.groups() {
        println("\{group}")
      }
    }
    println("Done")
  } catch {
    error => println("Error: \{error}")
  }
}
