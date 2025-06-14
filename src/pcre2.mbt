///|
extern "c" fn pcre2_INFO_NAMECOUNT() -> UInt = "moonbit_pcre2_INFO_NAMECOUNT"

///|
extern "c" fn pcre2_INFO_NAMEENTRYSIZE() -> UInt = "moonbit_pcre2_INFO_NAMEENTRYSIZE"

///|
extern "c" fn pcre2_INFO_NAMETABLE() -> UInt = "moonbit_pcre2_INFO_NAMETABLE"

///|
extern "c" fn pcre2_INFO_NEWLINE() -> UInt = "moonbit_pcre2_INFO_NEWLINE"

///|
extern "c" fn pcre2_NEWLINE_CR() -> UInt = "moonbit_pcre2_NEWLINE_CR"

///|
extern "c" fn pcre2_NEWLINE_CRLF() -> UInt = "moonbit_pcre2_NEWLINE_CRLF"

///|
extern "c" fn pcre2_NEWLINE_LF() -> UInt = "moonbit_pcre2_NEWLINE_LF"

///|
extern "c" fn pcre2_NEWLINE_ANY() -> UInt = "moonbit_pcre2_NEWLINE_ANY"

///|
extern "c" fn pcre2_NEWLINE_ANYCRLF() -> UInt = "moonbit_pcre2_NEWLINE_ANYCRLF"

///|
extern "c" fn pcre2_SUBSTITUTE_OVERFLOW_LENGTH() -> UInt = "moonbit_pcre2_SUBSTITUTE_OVERFLOW_LENGTH"

///|
extern "c" fn pcre2_ERROR_NOMEMORY() -> Int = "moonbit_pcre2_ERROR_NOMEMORY"

///|
extern "c" fn pcre2_ERROR_NOMATCH() -> Int = "moonbit_pcre2_ERROR_NOMATCH"

///|
extern "c" fn pcre2_NOTEMPTY_ATSTART() -> UInt = "moonbit_pcre2_NOTEMPTY_ATSTART"

///|
extern "c" fn pcre2_ANCHORED() -> UInt = "moonbit_pcre2_ANCHORED"

///|
pub enum Pcre2Newline {
  CR
  LF
  CRLF
  Any
  AnyCRLF
  Nul
}

///|
fn Pcre2Newline::of_uint(value : UInt) -> Pcre2Newline {
  if value == pcre2_NEWLINE_CR() {
    Pcre2Newline::CR
  } else if value == pcre2_NEWLINE_LF() {
    Pcre2Newline::LF
  } else if value == pcre2_NEWLINE_CRLF() {
    Pcre2Newline::CRLF
  } else if value == pcre2_NEWLINE_ANY() {
    Pcre2Newline::Any
  } else if value == pcre2_NEWLINE_ANYCRLF() {
    Pcre2Newline::AnyCRLF
  } else {
    Pcre2Newline::Nul
  }
}

///|
fn Code::newline(self : Code) -> Pcre2Newline!Pcre2Error {
  let newline = FixedArray::make(1, 0U)
  let result = pcre2_pattern_info_uint(self._, pcre2_INFO_NEWLINE(), newline)
  if result != 0 {
    raise Pcre2Error::Code(result)
  }
  Pcre2Newline::of_uint(newline[0])
}

///|
fn Code::name_count(self : Code) -> UInt!Pcre2Error {
  let name_count = FixedArray::make(1, 0U)
  let result = pcre2_pattern_info_uint(
    self._,
    pcre2_INFO_NAMECOUNT(),
    name_count,
  )
  if result != 0 {
    raise Pcre2Error::Code(result)
  }
  name_count[0]
}

///|
fn Code::name_table(self : Code) -> @c.Pointer[UInt16]!Pcre2Error {
  let name_table = FixedArray::make(1, @c.null())
  let result = pcre2_pattern_info_uint16_pointer(
    self._,
    pcre2_INFO_NAMETABLE(),
    name_table,
  )
  if result != 0 {
    raise Pcre2Error::Code(result)
  }
  name_table[0]
}

///|
fn Code::name_entry_size(self : Code) -> UInt!Pcre2Error {
  let name_entry_size = FixedArray::make(1, 0U)
  let result = pcre2_pattern_info_uint(
    self._,
    pcre2_INFO_NAMEENTRYSIZE(),
    name_entry_size,
  )
  if result != 0 {
    raise Pcre2Error::Code(result)
  }
  name_entry_size[0]
}

///|
priv type Pcre2Code

///|
priv extern type Pcre2CompileContext

///|
priv extern type Pcre2GeneralContext

///|
priv type Pcre2MatchData

///|
priv extern type Pcre2MatchContext

///|
typealias Pcre2Size = UInt64

///|
extern "c" fn pcre2_get_error_message(
  error_code : Int,
  buffer : String,
  buffer_length : Pcre2Size
) -> Int = "moonbit_pcre2_get_error_message"

///|
extern "c" fn pcre2_compile(
  pattern : String,
  length : Pcre2Size,
  options : UInt,
  error_code : FixedArray[Int],
  error_offset : FixedArray[Pcre2Size],
  context : @c.Nullable[Pcre2CompileContext]
) -> @c.Nullable[Pcre2Code] = "moonbit_pcre2_compile"

///|
extern "c" fn pcre2_match_data_create_from_pattern(
  code : Pcre2Code,
  context : @c.Nullable[Pcre2GeneralContext]
) -> Pcre2MatchData = "moonbit_pcre2_match_data_create_from_pattern"

///|
extern "c" fn pcre2_get_ovector_pointer(
  match_data : Pcre2MatchData
) -> @c.Pointer[Pcre2Size] = "moonbit_pcre2_get_ovector_pointer"

///|
extern "c" fn pcre2_substitute(
  code : Pcre2Code,
  subject : String,
  length : Pcre2Size,
  start_offset : Pcre2Size,
  options : UInt,
  match_data : Pcre2MatchData,
  match_context : @c.Nullable[Pcre2MatchContext],
  replacement : String,
  replacement_length : Pcre2Size,
  output_buffer : String,
  output_length : FixedArray[Pcre2Size]
) -> Int = "pcre2_substitute_16"

///|
extern "c" fn pcre2_get_startchar(match_data : Pcre2MatchData) -> Pcre2Size = "moonbit_pcre2_get_startchar"

///|
extern "c" fn pcre2_match(
  code : Pcre2Code,
  subject : String,
  length : Pcre2Size,
  start_offset : Pcre2Size,
  options : UInt,
  match_data : Pcre2MatchData,
  context : @c.Nullable[Pcre2MatchContext]
) -> Int = "moonbit_pcre2_match"

///|
extern "c" fn pcre2_pattern_info_uint(
  code : Pcre2Code,
  what : UInt,
  where_ : FixedArray[UInt]
) -> Int = "moonbit_pcre2_pattern_info_uint32"

///|
extern "c" fn pcre2_pattern_info_uint16_pointer(
  code : Pcre2Code,
  what : UInt,
  where_ : FixedArray[@c.Pointer[UInt16]]
) -> Int = "moonbit_pcre2_pattern_info_uint16_pointer"

///|
type Code Pcre2Code

///|
pub fn compile(pattern : String) -> Code!Pcre2Error {
  let error_code = FixedArray::make(1, 0)
  let error_offset = FixedArray::make(1, (0 : Pcre2Size))
  let code = pcre2_compile(
    pattern,
    pattern.length().to_uint64(),
    0,
    error_code,
    error_offset,
    @c.none(),
  ).to()
  match code {
    Some(code) => code
    None =>
      if error_code[0] > 0 {
        raise Pcre2Error::Compile(pattern, error_code[0], error_offset[0])
      } else {
        raise Pcre2Error::Code(error_code[0])
      }
  }
}

///|
struct Match {
  subject : String
  code_unit_offsets : FixedArray[Int]
  character_offsets : FixedArray[Int]
  name_table : Map[String, Int]
}

///|
trait MatchIndex {
  get(Match, Self) -> @string.View
}

///|
pub impl MatchIndex for Int with get(self : Match, index : Int) -> @string.View {
  let start = self.character_offsets[index * 2]
  let end = self.character_offsets[index * 2 + 1]
  self.subject.view(start_offset=start, end_offset=end)
}

///|
pub impl MatchIndex for String with get(self : Match, index : String) -> @string.View {
  let index = self.name_table.get(index).unwrap()
  let start = self.character_offsets[index * 2]
  let end = self.character_offsets[index * 2 + 1]
  self.subject.view(start_offset=start, end_offset=end)
}

///|
pub fn[Index : MatchIndex] Match::op_get(self : Match, index : Index) -> @string.View {
  Index::get(self, index)
}

///|
pub fn Match::groups(self : Match) -> Iter2[Int, @string.View] {
  Iter2::new(fn(yield_) {
    for i in 0..<(self.character_offsets.length() / 2) {
      let start = self.character_offsets[2 * i]
      let end = self.character_offsets[2 * i + 1]
      match yield_(i, self.subject.view(start_offset=start, end_offset=end)) {
        IterEnd => return IterEnd
        IterContinue => continue
      }
    }
    IterContinue
  })
}

///|
pub fn Match::named_groups(self : Match) -> Iter2[String, @string.View] {
  Iter2::new(fn(yield_) {
    for name, index in self.name_table {
      let start = self.character_offsets[2 * index]
      let end = self.character_offsets[2 * index + 1]
      match
        yield_(name, self.subject.view(start_offset=start, end_offset=end)) {
        IterEnd => return IterEnd
        IterContinue => continue
      }
    }
    IterContinue
  })
}

///|
pub type! Pcre2Error {
  LookaroundBSK
  Unicode(UnicodeError)
  Compile(String, Int, Pcre2Size)
  Code(Int)
}

///|
pub impl Show for Pcre2Error with output(self : Pcre2Error, logger : &Logger) -> Unit {
  fn write_error_message(code : Int, logger : &Logger) -> Unit {
    let message = String::make(256, '\u{00}')
    let length = message.length().to_uint64()
    let length = pcre2_get_error_message(code, message, length)
    if length < 0 {
      logger.write_string("Unknown error")
    } else {
      logger.write_string([..message.view(end_offset=length)])
    }
  }

  match self {
    LookaroundBSK => logger.write_string("Lookaround BSK")
    Unicode(error) => logger.write_string("Unicode error: \{error}")
    Compile(pattern, code, offset) => {
      logger.write_string("Compilation error @ \{offset}: ")
      write_error_message(code, logger)
      logger.write_char('\n')
      let start = @math.maximum(0, offset.to_int() - 10)
      let end = @math.minimum(pattern.length(), offset.to_int() + 10)
      logger.write_substring(pattern, start, end)
      for _ in 0..<start {
        logger.write_char(' ')
      }
      logger.write_char('^')
      for _ in (start + 1)..<end {
        logger.write_char(' ')
      }
    }
    Code(code) => write_error_message(code, logger)
  }
}

///|
fn array_to_string(array : FixedArray[UInt16]) -> String = "%identity"

///|
pub type! UnicodeError {
  InvalidCodeUnitOffset(Int)
  InvalidSurrogatePair
} derive(Show)

///|
fn is_leading_surrogate(c : Int) -> Bool {
  c is (0xD800..=0xDBFF)
}

///|
fn is_trailing_surrogate(c : Int) -> Bool {
  c is (0xDC00..=0xDFFF)
}

///|
fn code_unit_to_character(
  string : String,
  code_unit_offsets~ : FixedArray[Int],
  character_offsets~ : FixedArray[Int],
  start_code_unit_offset~ : Int,
  start_character_offset~ : Int
) -> Unit!UnicodeError {
  let offsets_indices = FixedArray::makei(code_unit_offsets.length(), fn(i) {
    i
  })
  offsets_indices.sort_by(fn(a, b) {
    code_unit_offsets[a].compare(code_unit_offsets[b])
  })
  let mut character_offset = start_character_offset
  let mut code_unit_offset = start_code_unit_offset
  for oi in offsets_indices {
    while code_unit_offset < code_unit_offsets[oi] {
      let c1 = string.charcode_at(code_unit_offset)
      if is_leading_surrogate(c1) {
        if code_unit_offset + 1 == code_unit_offsets[oi] {
          raise InvalidCodeUnitOffset(code_unit_offsets[oi])
        }
        let c2 = string.charcode_at(code_unit_offset + 1)
        if is_trailing_surrogate(c2) {
          code_unit_offset += 2
          character_offset += 1
        } else {
          raise InvalidSurrogatePair
        }
      } else {
        code_unit_offset += 1
        character_offset += 1
      }
    }
    character_offsets[oi] = character_offset
  }
}

///|
struct Matches {
  code : Code
  subject : String
  subject_length : Pcre2Size
  mut match_data : Pcre2MatchData?
  crlf_is_newline : Bool
  mut ovector : @c.Pointer[Pcre2Size]
  mut start_code_unit_offset : Int
  mut start_character_offset : Int
  name_count : Int
  name_table : @c.Pointer[UInt16]
  name_entry_size : Int
}

///|
fn Matches::update_offsets(self : Matches, offset : Int) -> Unit!Pcre2Error {
  while self.start_code_unit_offset < offset {
    let c1 = self.subject.charcode_at(self.start_code_unit_offset)
    if is_leading_surrogate(c1) {
      if self.start_code_unit_offset + 1 == offset {
        raise Pcre2Error::Unicode(InvalidCodeUnitOffset(offset))
      }
      let c2 = self.subject.charcode_at(self.start_code_unit_offset + 1)
      if is_trailing_surrogate(c2) {
        self.start_code_unit_offset += 2
        self.start_character_offset += 1
      } else {
        raise Pcre2Error::Unicode(InvalidSurrogatePair)
      }
    } else {
      self.start_code_unit_offset += 1
      self.start_character_offset += 1
    }
  }
}

///|
/// Retrieves the next match from the iterator, advancing the internal state to
/// find subsequent matches in the subject string.
///
/// This method implements the core pattern matching logic, handling various edge
/// cases including empty matches, lookaround assertions with `\K`, and proper
/// Unicode character boundary handling. It maintains internal state to ensure
/// all matches are found in sequence without duplicates or infinite loops.
///
/// Parameters:
///
/// * `self` : The `Matches` iterator containing the compiled pattern, subject
/// string, and matching state.
///
/// Returns `Some(Match)` containing the next match with capturing groups and
/// named groups, or `None` if no more matches are found.
///
/// Throws `Pcre2Error` in the following cases:
///
/// * `Pcre2Error::Code(Int)` for general PCRE2 matching errors
/// * `Pcre2Error::Unicode(UnicodeError)` for Unicode-related errors during
/// character offset conversion
/// * `Pcre2Error::LookaroundBSK` when encountering problematic lookaround
/// assertions with `\K`
///
/// Examples:
///
/// ```moonbit
/// test "Matches::next" {
///   let pattern = @pcre2.compile("\\d+")
///   let matches = pattern.matches("abc123def456")
///   let first = matches.next().unwrap()
///   inspect(first[0], content="123")
///   let second = matches.next().unwrap()
///   inspect(second[0], content="456")
///   assert_true(matches.next() is None)
/// }
/// ```
///
/// ```moonbit
/// test "Matches::next/empty_matches" {
///   let pattern = @pcre2.compile("a*")
///   let matches = pattern.matches("aabaa")
///   let first = matches.next().unwrap()
///   inspect(first[0], content="aa")
///   let second = matches.next().unwrap()
///   inspect(second[0], content="")  // empty match between 'b' and 'a'
/// }
/// ```
///
/// ```moonbit
/// test "Matches::next/named_groups" {
///   let pattern = @pcre2.compile("(?P<num>\\d+)")
///   let matches = pattern.matches("number: 42")
///   let match_result = matches.next().unwrap()
///   inspect(match_result["num"], content="42")
///   inspect(match_result[0], content="42")
/// }
/// ```
pub fn Matches::next(self : Matches) -> Match?!Pcre2Error {
  guard self.match_data is Some(match_data) else { return None }
  fn next() -> Match?!Pcre2Error {
    let rc = if self.ovector.is_null() {
      let rc = pcre2_match(
        self.code._,
        self.subject,
        self.subject_length,
        0,
        0,
        match_data,
        @c.none(),
      )
      if rc == pcre2_ERROR_NOMATCH() {
        return None
      }
      self.ovector = pcre2_get_ovector_pointer(match_data)
      rc
    } else {
      let mut options = 0U // Normally no options
      let mut start_offset = self.ovector[1] // Start at end of previous match
      self.update_offsets(start_offset.to_int())

      // If the previous match was for an empty string, we are finished if we are
      // at the end of the subject. Otherwise, arrange to run another match at the
      // same point to see if a non-empty match can be found.

      if self.ovector[0] == self.ovector[1] {
        if self.ovector[0] == self.subject_length {
          return None
        }
        options = pcre2_NOTEMPTY_ATSTART() | pcre2_ANCHORED()
      } else {
        // If the previous match was not an empty string, there is one tricky case to
        // consider. If a pattern contains \K within a lookbehind assertion at the
        // start, the end of the matched string can be at the offset where the match
        // started. Without special action, this leads to a loop that keeps on matching
        // the same substring. We must detect this case and arrange to move the start on
        // by one character. The pcre2_get_startchar() function returns the starting
        // offset that was passed to pcre2_match().
        let startchar = pcre2_get_startchar(match_data)
        if start_offset <= startchar {
          if startchar >= self.subject_length {
            return None
          }
          start_offset = startchar + 1
        }
      }
      let rc = pcre2_match(
        self.code._,
        self.subject,
        self.subject_length,
        start_offset,
        options,
        match_data,
        @c.none(),
      )

      // This time, a result of NOMATCH isn't an error. If the value in "options"
      // is zero, it just means we have found all possible matches, so the loop ends.
      // Otherwise, it means we have failed to find a non-empty-string match at a
      // point where there was a previous empty-string match. In this case, we do
      // what Perl does: advance the matching position by one character, and
      // continue. We do this by setting the "end of previous match" offset, because
      // that is picked up at the top of the loop as the point at which to start
      // again.

      // There are two complications: (a) When CRLF is a valid newline sequence, and
      // the current position is just before it, advance by an extra byte. (b)
      // Otherwise we must ensure that we skip an entire UTF character if we are in
      // UTF mode.

      if rc == pcre2_ERROR_NOMATCH() {
        if options == 0U {
          return None // All matches found
        }
        self.ovector[1] = start_offset + 1 // Advance one code unit
        if self.crlf_is_newline && // If CRLF is a newline & we are at CRLF
          start_offset < self.subject_length - 1 &&
          self.subject.charcode_at(start_offset.to_int()) == '\r' &&
          self.subject.charcode_at(start_offset.to_int() + 1) == '\n' {
          self.ovector[1] += 1 // Advance by one more code unit
        }
        // NOTE(translator): The original code test if the UTF8 flag is set. However,
        // we are using UTF16, so we can skip the check.
        return self.next() // Go round the loop again
      }
      rc
    }

    // Other matching errors are not recoverable.

    if rc < 0 {
      raise Pcre2Error::Code(rc)
    }

    // The match succeeded, but the output vector wasn't big enough. This
    // should not happen.
    if rc == 0 {
      abort("Ovector was not big enough")
    }

    // We must guard against patterns such as /(?=.\K)/ that use \K in an
    // assertion to set the start of a match later than its end. In this
    // demonstration program, we just detect this case and give up.

    if self.ovector[0] > self.ovector[1] {
      raise Pcre2Error::LookaroundBSK
    }

    // As before, show substrings stored in the output vector by number, and
    // then also any named substrings.
    // NOTE(translator): The pcre2demo.c prints the matches to the console. We
    // return the match here instead.
    let matched = Match::{
      subject: self.subject,
      code_unit_offsets: FixedArray::make(2 * rc, 0),
      character_offsets: FixedArray::make(2 * rc, 0),
      name_table: {},
    }
    for i in 0..<rc {
      matched.code_unit_offsets[2 * i] = self.ovector[2 * i].to_int()
      matched.code_unit_offsets[2 * i + 1] = self.ovector[2 * i + 1].to_int()
    }
    try
      code_unit_to_character(
        self.subject,
        code_unit_offsets=matched.code_unit_offsets,
        character_offsets=matched.character_offsets,
        start_code_unit_offset=self.start_code_unit_offset,
        start_character_offset=self.start_character_offset,
      ) catch {
      error => raise Pcre2Error::Unicode(error)
    }

    // Now we can scan the table and, for each entry, print the number, the
    // name, and the substring itself. In the 8-bit library the number is held in
    // two bytes, most significant first.

    for i in 0..<self.name_count {
      // PCRE2_INFO_NAMETABLE returns a pointer to the first entry of the
      // table. This is a PCRE2_SPTR pointer to a block of code units. In the
      // 8-bit library, the first two bytes of each entry are the number of the
      // capturing parenthesis, most significant byte first. In the 16-bit
      // library, the pointer points to 16-bit code units, the first of which
      // contains the parenthesis number. In the 32-bit library, the pointer
      // points to 32-bit code units, the first of which contains the
      // parenthesis number. The rest of the entry is the corresponding name,
      // zero terminated.
      let n = self.name_table[0]
      let name : FixedArray[UInt16] = FixedArray::make(
        self.name_entry_size - 2,
        0,
      )
      for j in 1..<(self.name_entry_size - 1) {
        name[j - 1] = self.name_table[j]
      }
      let name = array_to_string(name)
      matched.name_table.set(name, n.to_int())
    }
    return Some(matched)
  }

  try {
    if next() is Some(matched) {
      Some(matched)
    } else {
      self.match_data = None
      None
    }
  } catch {
    error => {
      self.match_data = None
      raise error
    }
  }
}

///|
/// Creates an iterator over all matches of the pattern in a subject string. Each
/// match contains both numbered and named capturing groups.
///
/// Parameters:
///
/// * `self` : A compiled regular expression pattern.
/// * `subject` : The string to search for matches.
///
/// Returns a `Matches` iterator that yields each match in sequence. Each match
/// contains information about the matched substring and any capturing groups.
///
/// Throws `Pcre2Error` if an error occurs during pattern matching.
///
/// Example:
///
/// ```moonbit
/// test "Code::matches" {
///   let pattern = @pcre2.compile("[0-9]+")
///   let matches = pattern.matches("abc123def456")
///   let first = matches.next().unwrap()
///   inspect(first[0], content="123")
///   let second = matches.next().unwrap()
///   inspect(second[0], content="456")
///   assert_true(matches.next() is None)
/// }
/// ```
pub fn Code::matches(self : Code, subject : String) -> Matches!Pcre2Error {
  // The following code has been adapted from the pcre2demo.c file in the PCRE2
  // library.
  let match_data = pcre2_match_data_create_from_pattern(self._, @c.none())
  let subject_length = subject.length().to_uint64()
  let crlf_is_newline = match self.newline() {
    Any | CRLF | AnyCRLF => true
    _ => false
  }
  let ovector = @c.null()
  let start_code_unit_offset = 0
  let start_character_offset = 0
  let name_count = self.name_count().reinterpret_as_int()
  let name_table = self.name_table()
  let name_entry_size = self.name_entry_size().reinterpret_as_int()
  return Matches::{
    code: self,
    subject,
    subject_length,
    match_data: Some(match_data),
    crlf_is_newline,
    ovector,
    start_code_unit_offset,
    start_character_offset,
    name_count,
    name_table,
    name_entry_size,
  }
}

///|
pub fn substitute(
  self : Code,
  subject : String,
  replacement : String
) -> String {
  let match_data = pcre2_match_data_create_from_pattern(self._, @c.none())
  let subject_length = subject.length().to_uint64()
  let replacement_length = replacement.length().to_uint64()
  let output_length : FixedArray[UInt64] = [subject.length().to_uint64() * 2]
  while true {
    let output = String::make(output_length[0].to_int(), '\u{00}')
    let options = pcre2_SUBSTITUTE_OVERFLOW_LENGTH()
    let start_offset = 0UL
    let rc = pcre2_substitute(
      self._,
      subject,
      subject_length,
      start_offset,
      options,
      match_data,
      @c.none(),
      replacement,
      replacement_length,
      output,
      output_length,
    )
    if rc < 0 {
      if rc == pcre2_ERROR_NOMEMORY() {
        continue
      }
    }
    break output
  } else {
    abort("unreachable")
  }
}
