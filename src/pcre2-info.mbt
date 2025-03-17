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
