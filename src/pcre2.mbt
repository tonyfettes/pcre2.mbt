///|
extern "c" fn pcre2_get_error_message(
  errorcode : Int,
  buffer : @c.Pointer[Pcre2Uchar],
  bufflen : Pcre2Size
) -> Int = "pcre2_get_error_message_16"

///|
priv extern type Pcre2Code

///|
type Code Pcre2Code

///|
pub fn compile(pattern : String) -> Code {
  let errorcode = FixedArray::make(1, 0)
  let erroroffset = FixedArray::make(1, (0 : Pcre2Size))
  pcre2_compile(
    pattern,
    pattern.length(),
    0,
    errorcode,
    erroroffset,
    @c.Nullable::of(None),
  )
}

///|
pub fn Code::free(self : Code) -> Unit {
  pcre2_code_free(self._)
}

///|
priv extern type Pcre2CompileContext

///|
extern "c" fn pcre2_compile(
  pattern : String,
  length : Int,
  options : UInt,
  errorcode : FixedArray[Int],
  erroroffset : FixedArray[Pcre2Size],
  context : @c.Nullable[Pcre2CompileContext]
) -> Pcre2Code = "pcre2_compile_16"

///|
extern "c" fn pcre2_code_free(code : Pcre2Code) = "pcre2_code_free_16"

///|
priv extern type Pcre2GeneralContext

///|
priv extern type Pcre2MatchData

///|
struct Capture {
  match_ : Match
  name : String
  index : Int
}

///|
pub fn Capture::name(self : Capture) -> String {
  self.name
}

///|
pub fn Capture::range(self : Capture) -> (Int, Int) {
  let start = self.match_.character_offsets[self.index * 2]
  let end = self.match_.character_offsets[self.index * 2 + 1]
  (start, end)
}

///|
priv struct Pcre2StringView {
  str : String
  start : Int
  end : Int
}

///|
fn Pcre2StringView::to(self : Pcre2StringView) -> @string.View = "%identity"

///|
fn Pcre2StringView::of(view : @string.View) -> Pcre2StringView = "%identity"

///|
pub fn Capture::view(self : Capture) -> @string.View {
  let start = self.match_.code_unit_offsets[self.index * 2]
  let end = self.match_.code_unit_offsets[self.index * 2 + 1]
  let view = Pcre2StringView::{ str: self.match_.subject, start, end }
  view.to()
}

///|
struct Match {
  subject : String
  code_unit_offsets : FixedArray[Int]
  character_offsets : FixedArray[Int]
  captures : Array[Capture]
}

///|
pub fn Match::offsets(self : Match) -> Iter[Int] {
  self.character_offsets.iter()
}

///|
pub fn Match::ranges(self : Match) -> Iter2[Int, Int] {
  Iter2::new(fn(yield_) {
    for i in 0..<(self.character_offsets.length() / 2) {
      match
        yield_(self.character_offsets[i * 2], self.character_offsets[i * 2 + 1]) {
        IterEnd => return IterEnd
        IterContinue => continue
      }
    }
    IterContinue
  })
}

///|
pub fn Match::captures(self : Match) -> Iter2[String, Capture] {
  Iter2::new(fn(yield_) {
    for capture in self.captures {
      let name = capture.name
      match yield_(name, capture) {
        IterEnd => return IterEnd
        IterContinue => continue
      }
    }
    IterContinue
  })
}

///|
extern "c" fn pcre2_match_data_create_from_pattern(
  code : Pcre2Code,
  context : @c.Nullable[Pcre2GeneralContext]
) -> Pcre2MatchData = "pcre2_match_data_create_from_pattern_16"

///|
extern "c" fn pcre2_match_data_free(match_data : Pcre2MatchData) = "pcre2_match_data_free_16"

///|
priv extern type Pcre2MatchContext

///|
extern "c" fn pcre2_match(
  code : Pcre2Code,
  subject : String,
  length : Pcre2Size,
  start_offset : Pcre2Size,
  options : UInt,
  match_data : Pcre2MatchData,
  context : @c.Nullable[Pcre2MatchContext]
) -> Int = "pcre2_match_16"

///|
extern "c" fn pcre2_ERROR_NOMATCH() -> Int = "moonbit_pcre2_ERROR_NOMATCH"

///|
extern "c" fn pcre2_NOTEMPTY_ATSTART() -> UInt = "moonbit_pcre2_NOTEMPTY_ATSTART"

///|
extern "c" fn pcre2_ANCHORED() -> UInt = "moonbit_pcre2_ANCHORED"

///|
pub type! Pcre2Error {
  LookaroundBSK
  Null
  BadMagic
  BadOption
  BadMode
  Unset
  Unicode(UnicodeError)
  Error(String)
} derive(Show)

///|
type Ater[T] () -> T?!Pcre2Error

///|
pub fn Ater::next[T](self : Ater[T]) -> T?!Pcre2Error {
  (self._)!()
}

///|
fn string_to_array(string : String) -> FixedArray[UInt16] = "%identity"

///|
fn array_to_string(array : FixedArray[UInt16]) -> String = "%identity"

///|
pub type! UnicodeError {
  InvalidCodeUnitOffset(Int)
  InvalidSurrogatePair
} derive(Show)

///|
fn is_leading_surrogate(c : UInt16) -> Bool {
  c is (0xD800..=0xDBFF)
}

///|
fn is_trailing_surrogate(c : UInt16) -> Bool {
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
  let string = string_to_array(string)
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
pub fn Code::matches(self : Code, subject : String) -> Ater[Match] {
  // The following code has been adapted from the pcre2demo.c file in the PCRE2
  // library.
  let match_data = pcre2_match_data_create_from_pattern(
    self._,
    @c.Nullable::none(),
  )
  let subject_array = string_to_array(subject)
  let subject_length = subject.length().to_uint64()
  let crlf_is_newline = match pcre2_pattern_info_newline(self._) {
    Any | CRLF | AnyCRLF => true
    _ => false
  }
  let mut ovector = @c.null()
  let mut start_code_unit_offset = 0
  let mut start_character_offset = 0
  let name_count = pcre2_pattern_info_name_count(self._)
  let name_table = pcre2_pattern_info_name_table(self._)
  let name_entry_size = pcre2_pattern_info_name_entry_size(self._).reinterpret_as_int()
  fn pcre2_error(rc) -> Unit!Pcre2Error {
    let buffer : Bytes = Bytes::make(1024, 0)
    let length = buffer.length().to_uint64() / 4
    let length = pcre2_get_error_message(
      rc,
      @c.Pointer::of_bytes(buffer).cast(),
      length,
    )
    let error_message = @encoding.decoder(UTF16).decode_lossy(
      [..buffer[:length]],
    )
    pcre2_match_data_free(match_data)
    raise Pcre2Error::Error([..error_message])
  }

  fn update_offsets(offset : Int) -> Unit!Pcre2Error {
    while start_code_unit_offset < offset {
      let c1 = subject_array[start_code_unit_offset]
      if is_leading_surrogate(c1) {
        if start_code_unit_offset + 1 == offset {
          raise Pcre2Error::Unicode(InvalidCodeUnitOffset(offset))
        }
        let c2 = subject_array[start_code_unit_offset + 1]
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
    while true {
      let rc = if ovector.is_null() {
        let rc = pcre2_match(
          self._,
          subject,
          subject_length,
          0,
          0,
          match_data,
          @c.Nullable::none(),
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
          if ovector[0] == subject.length().to_uint64() {
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
            if startchar >= subject.length().to_uint64() {
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
          @c.Nullable::none(),
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
        pcre2_error!(rc)
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
        pcre2_match_data_free(match_data)
        raise LookaroundBSK
      }

      // As before, show substrings stored in the output vector by number, and
      // then also any named substrings.
      // NOTE(translator): The pcre2demo.c prints the matches to the console. We
      // return the match here instead.
      let match_ = Match::{
        subject,
        code_unit_offsets: FixedArray::make(2 * rc, 0),
        character_offsets: FixedArray::make(2 * rc, 0),
        captures: [],
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
        let name : FixedArray[UInt16] = FixedArray::make(name_entry_size - 1, 0)
        for j in 1..<name_entry_size {
          name[j - 1] = name_table[j]
        }
        let name = array_to_string(name)
        match_.captures.push(Capture::{ match_, name, index: n.to_int() })
      }
      return Some(match_)
    }
    pcre2_match_data_free(match_data)
    None
  }
}

///|
typealias Pcre2Size = UInt64

///|
extern "c" fn pcre2_get_ovector_pointer(
  match_data : Pcre2MatchData
) -> @c.Pointer[Pcre2Size] = "pcre2_get_ovector_pointer_16"

///|
extern "c" fn pcre2_get_ovector_count(match_data : Pcre2MatchData) -> UInt = "pcre2_get_ovector_count_16"

///|
typealias Pcre2Uchar = UInt16

///|
extern "c" fn pcre2_substitute(
  code : Pcre2Code,
  subject : String,
  length : Pcre2Size,
  start_offset : Int,
  options : UInt,
  match_data : Pcre2MatchData,
  mcontext : @c.Nullable[Pcre2MatchContext],
  replacement : String,
  rlength : Pcre2Size,
  outputbuffer : FixedArray[Pcre2Uchar],
  outlengthptr : @c.Pointer[Pcre2Size]
) -> Int = "pcre2_substitute_16"

///|
enum Pcre2BSR {
  Unicode
  AnyCRLF
}

///|
enum Pcre2InfoFirstCodeType {
  NothingSet
  FirstCodeUnitIsSet
  StartOfStringOrAfterNewline
}

///|
enum Pcre2InfoLastCodeType {
  NothingSet
  CodeUnitIsSet
}

///|
typealias Pcre2Sptr = @c.Pointer[Pcre2Uchar]

///|
extern "c" fn pcre2_get_startchar(match_data : Pcre2MatchData) -> Pcre2Size = "moonbit_pcre2_get_startchar"
