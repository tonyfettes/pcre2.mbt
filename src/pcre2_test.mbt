///|
test "captures" {
  let code = @pcre2.compile("(?<hello>hello)")
  let subject = "a hello, 你好  world! hello"
  let views = []
  let matches = code.matches(subject)
  while matches.next() is Some(matched) {
    for _, capture in matched.named_groups() {
      views.push(capture.to_string())
    }
  }
  @json.inspect(views, content=["hello", "hello"])
}

///|
test "named_groups" {
  let code = @pcre2.compile("(?<num>\\d+)")
  let matches = code.matches("number: 42")
  let match_result = matches.next().unwrap()
  @json.inspect(match_result["num"], content="42")
}

///|
test "split" {
  let code = @pcre2.compile(
    "'s|'t|'re|'ve|'m|'ll|'d| ?\\p{L}+| ?\\p{N}+| ?[^\\s\\p{L}\\p{N}]+|\\s+(?!\\S)|\\s+",
  )
  let subject = "He's a good person"
  let splits = []
  let matches = code.matches(subject)
  while matches.next() is Some(match_) {
    for _, capture in match_.groups() {
      splits.push(capture.to_string())
    }
  }
  @json.inspect(splits, content=["He", "'s", " a", " good", " person"])
}

///|
test "cl100k_base" {
  let code = @pcre2.compile(
    "'(?i:[sdmt]|ll|ve|re)|[^\\r\\n\\p{L}\\p{N}]?+\\p{L}++|\\p{N}{1,3}+| ?[^\\s\\p{L}\\p{N}]++[\\r\\n]*+|\\s++$|\\s*[\\r\\n]|\\s+(?!\\S)|\\s",
  )
  let subject = "你好，世界🌍"
  let splits = []
  let matches = code.matches(subject)
  while matches.next() is Some(matched) {
    splits.push(matched[0])
  }
  @json.inspect(splits, content=["你好", "，世界", "🌍"])
}

///|
test "cl100k_base/view" {
  let code = @pcre2.compile(
    "'(?i:[sdmt]|ll|ve|re)|[^\\r\\n\\p{L}\\p{N}]?+\\p{L}++|\\p{N}{1,3}+| ?[^\\s\\p{L}\\p{N}]++[\\r\\n]*+|\\s++$|\\s*[\\r\\n]|\\s+(?!\\S)|\\s",
  )
  let subject = "abcdefg你好，世界🌍"
  let subject = subject[7:]
  @json.inspect(subject, content="你好，世界🌍")
  let splits = []
  let matches = code.matches(subject)
  while matches.next() is Some(matched) {
    splits.push(matched[0])
  }
  @json.inspect(splits, content=["你好", "，世界", "🌍"])
}

///|
test "substitution" {
  let code = @pcre2.compile("\\b(\\w+)\\b")
  let subject = "Hello world!"
  let matches = code.matches(subject)
  let results = []
  while matches.next() is Some(matched) {
    results.push(matched[0].to_string())
  }
  @json.inspect(results, content=["Hello", "world"])
  @json.inspect(
    code.substitute(subject, "<$1>", global=true),
    content="<Hello> <world>!",
  )
}

///|
test "substitution/view" {
  let code = @pcre2.compile("\\b(\\w+)\\b")
  let subject = "Hello world!"
  let subject = subject[6:11]
  @json.inspect(subject, content="world")
  let matches = code.matches(subject)
  let results = []
  while matches.next() is Some(matched) {
    results.push(matched[0].to_string())
  }
  @json.inspect(results, content=["world"])
  let replacement = "<<$1>>"
  let replacement = replacement[1:5]
  @json.inspect(replacement, content="<$1>")
  @json.inspect(
    code.substitute(subject, replacement, global=true),
    content="<world>",
  )
}
