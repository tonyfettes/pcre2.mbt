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
impl MatchIndex for Int with get(self : Match, index : Int) -> @string.View {
  let start = self.character_offsets[index * 2]
  let end = self.character_offsets[index * 2 + 1]
  self.subject[start:end]
}

///|
impl MatchIndex for String with get(self : Match, index : String) -> @string.View {
  let index = self.name_table[index].unwrap()
  let start = self.character_offsets[index * 2]
  let end = self.character_offsets[index * 2 + 1]
  self.subject[start:end]
}

///|
pub fn Match::op_get[I : MatchIndex](self : Match, index : I) -> @string.View {
  I::get(self, index)
}

///|
pub fn Match::groups(self : Match) -> Iter2[Int, @string.View] {
  Iter2::new(fn(yield_) {
    for i in 0..<(self.character_offsets.length() / 2) {
      let start = self.character_offsets[2 * i]
      let end = self.character_offsets[2 * i + 1]
      match yield_(i, self.subject[start:end]) {
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
      match yield_(name, self.subject[start:end]) {
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
    let message = String::make(256, '\x00')
    let length = message.length().to_uint64()
    let length = pcre2_get_error_message(code, message, length)
    if length < 0 {
      logger.write_string("Unknown error")
    } else {
      logger.write_string([..message[:length]])
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
type Ator[T] () -> T?!Pcre2Error

///|
pub fn Ator::next[T](self : Ator[T]) -> T?!Pcre2Error {
  (self._)!()
}

///|
fn array_to_string(array : FixedArray[UInt16]) -> String = "%identity"

///|
pub type! UnicodeError {
  InvalidCodeUnitOffset(Int)
  InvalidSurrogatePair
} derive(Show)

///|
fn is_leading_surrogate(c : Char) -> Bool {
  c.to_int() is (0xD800..=0xDBFF)
}

///|
fn is_trailing_surrogate(c : Char) -> Bool {
  c.to_int() is (0xDC00..=0xDFFF)
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
      let c1 = string[code_unit_offset]
      if is_leading_surrogate(c1) {
        if code_unit_offset + 1 == code_unit_offsets[oi] {
          raise InvalidCodeUnitOffset(code_unit_offsets[oi])
        }
        let c2 = string[code_unit_offset + 1]
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
pub fn Code::matches(self : Code, subject : String) -> Ator[Match]!Pcre2Error {
  // The following code has been adapted from the pcre2demo.c file in the PCRE2
  // library.
  let match_data = pcre2_match_data_create_from_pattern(self._, @c.none())
  let subject_length = subject.length().to_uint64()
  let crlf_is_newline = match self.newline!() {
    Any | CRLF | AnyCRLF => true
    _ => false
  }
  let mut ovector = @c.null()
  let mut start_code_unit_offset = 0
  let mut start_character_offset = 0
  let name_count = self.name_count!()
  let name_table = self.name_table!()
  let name_entry_size = self.name_entry_size!().reinterpret_as_int()
  fn update_offsets(offset : Int) -> Unit!Pcre2Error {
    while start_code_unit_offset < offset {
      let c1 = subject[start_code_unit_offset]
      if is_leading_surrogate(c1) {
        if start_code_unit_offset + 1 == offset {
          raise Pcre2Error::Unicode(InvalidCodeUnitOffset(offset))
        }
        let c2 = subject[start_code_unit_offset + 1]
        if is_trailing_surrogate(c2) {
          start_code_unit_offset += 2
          start_character_offset += 1
        } else {
          raise Pcre2Error::Unicode(InvalidSurrogatePair)
        }
      } else {
        start_code_unit_offset += 1
        start_character_offset += 1
      }
    }
  }

  fn() {
    try {
      while true {
        let rc = if ovector.is_null() {
          let rc = pcre2_match(
            self._,
            subject,
            subject_length,
            0,
            0,
            match_data,
            @c.none(),
          )
          if rc == pcre2_ERROR_NOMATCH() {
            break
          }
          ovector = pcre2_get_ovector_pointer(match_data)
          rc
        } else {
          let mut options = 0U // Normally no options
          let mut start_offset = ovector[1] // Start at end of previous match
          update_offsets!(start_offset.to_int())

          // If the previous match was for an empty string, we are finished if we are
          // at the end of the subject. Otherwise, arrange to run another match at the
          // same point to see if a non-empty match can be found.

          if ovector[0] == ovector[1] {
            if ovector[0] == subject_length {
              break
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
              if startchar >= subject_length {
                break
              }
              start_offset = startchar + 1
            }
          }
          let rc = pcre2_match(
            self._,
            subject,
            subject_length,
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
              break // All matches found
            }
            ovector[1] = start_offset + 1 // Advance one code unit
            if crlf_is_newline && // If CRLF is a newline & we are at CRLF
              start_offset < subject_length - 1 &&
              subject[start_offset.to_int()] == '\r' &&
              subject[start_offset.to_int() + 1] == '\n' {
              ovector[1] += 1 // Advance by one more code unit
            }
            // NOTE(translator): The original code test if the UTF8 flag is set. However,
            // we are using UTF16, so we can skip the check.
            continue // Go round the loop again
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

        if ovector[0] > ovector[1] {
          raise Pcre2Error::LookaroundBSK
        }

        // As before, show substrings stored in the output vector by number, and
        // then also any named substrings.
        // NOTE(translator): The pcre2demo.c prints the matches to the console. We
        // return the match here instead.
        let match_ = Match::{
          subject,
          code_unit_offsets: FixedArray::make(2 * rc, 0),
          character_offsets: FixedArray::make(2 * rc, 0),
          name_table: {},
        }
        for i in 0..<rc {
          match_.code_unit_offsets[2 * i] = ovector[2 * i].to_int()
          match_.code_unit_offsets[2 * i + 1] = ovector[2 * i + 1].to_int()
        }
        try {
          code_unit_to_character!(
            subject,
            code_unit_offsets=match_.code_unit_offsets,
            character_offsets=match_.character_offsets,
            start_code_unit_offset~,
            start_character_offset~,
          )
        } catch {
          error => raise Pcre2Error::Unicode(error)
        }

        // Now we can scan the table and, for each entry, print the number, the
        // name, and the substring itself. In the 8-bit library the number is held in
        // two bytes, most significant first.

        for i in 0U..<name_count {
          // PCRE2_INFO_NAMETABLE returns a pointer to the first entry of the
          // table. This is a PCRE2_SPTR pointer to a block of code units. In the
          // 8-bit library, the first two bytes of each entry are the number of the
          // capturing parenthesis, most significant byte first. In the 16-bit
          // library, the pointer points to 16-bit code units, the first of which
          // contains the parenthesis number. In the 32-bit library, the pointer
          // points to 32-bit code units, the first of which contains the
          // parenthesis number. The rest of the entry is the corresponding name,
          // zero terminated.
          let n = name_table[0]
          let name : FixedArray[UInt16] = FixedArray::make(
            name_entry_size - 1,
            0,
          )
          for j in 1..<name_entry_size {
            name[j - 1] = name_table[j]
          }
          let name = array_to_string(name)
          match_.name_table.set(name, n.to_int())
        }
        return Some(match_)
      }
      pcre2_match_data_free(match_data)
      None
    } catch {
      error => {
        pcre2_match_data_free(match_data)
        raise error
      }
    }
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
    let output = String::make(output_length[0].to_int(), '\x00')
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
