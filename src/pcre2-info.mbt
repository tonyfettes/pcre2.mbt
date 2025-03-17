///|
extern "c" fn pcre2_INFO_ALLOPTIONS() -> UInt = "moonbit_pcre2_INFO_ALLOPTIONS"

///|
extern "c" fn pcre2_INFO_ARGOPTIONS() -> UInt = "moonbit_pcre2_INFO_ARGOPTIONS"

///|
extern "c" fn pcre2_INFO_BACKREFMAX() -> UInt = "moonbit_pcre2_INFO_BACKREFMAX"

///|
extern "c" fn pcre2_INFO_BSR() -> UInt = "moonbit_pcre2_INFO_BSR"

///|
extern "c" fn pcre2_INFO_CAPTURECOUNT() -> UInt = "moonbit_pcre2_INFO_CAPTURECOUNT"

///|
extern "c" fn pcre2_INFO_DEPTHLIMIT() -> UInt = "moonbit_pcre2_INFO_DEPTHLIMIT"

///|
extern "c" fn pcre2_INFO_EXTRAOPTIONS() -> UInt = "moonbit_pcre2_INFO_EXTRAOPTIONS"

///|
extern "c" fn pcre2_INFO_FIRSTBITMAP() -> UInt = "moonbit_pcre2_INFO_FIRSTBITMAP"

///|
extern "c" fn pcre2_INFO_FIRSTCODETYPE() -> UInt = "moonbit_pcre2_INFO_FIRSTCODETYPE"

///|
extern "c" fn pcre2_INFO_FIRSTCODEUNIT() -> UInt = "moonbit_pcre2_INFO_FIRSTCODEUNIT"

///|
extern "c" fn pcre2_INFO_FRAMESIZE() -> UInt = "moonbit_pcre2_INFO_FRAMESIZE"

///|
extern "c" fn pcre2_INFO_HASBACKSLASHC() -> UInt = "moonbit_pcre2_INFO_HASBACKSLASHC"

///|
extern "c" fn pcre2_INFO_HASCRORLF() -> UInt = "moonbit_pcre2_INFO_HASCRORLF"

///|
extern "c" fn pcre2_INFO_HEAPLIMIT() -> UInt = "moonbit_pcre2_INFO_HEAPLIMIT"

///|
extern "c" fn pcre2_INFO_JCHANGED() -> UInt = "moonbit_pcre2_INFO_JCHANGED"

///|
extern "c" fn pcre2_INFO_JITSIZE() -> UInt = "moonbit_pcre2_INFO_JITSIZE"

///|
extern "c" fn pcre2_INFO_LASTCODETYPE() -> UInt = "moonbit_pcre2_INFO_LASTCODETYPE"

///|
extern "c" fn pcre2_INFO_LASTCODEUNIT() -> UInt = "moonbit_pcre2_INFO_LASTCODEUNIT"

///|
extern "c" fn pcre2_INFO_MATCHEMPTY() -> UInt = "moonbit_pcre2_INFO_MATCHEMPTY"

///|
extern "c" fn pcre2_INFO_MATCHLIMIT() -> UInt = "moonbit_pcre2_INFO_MATCHLIMIT"

///|
extern "c" fn pcre2_INFO_MAXLOOKBEHIND() -> UInt = "moonbit_pcre2_INFO_MAXLOOKBEHIND"

///|
extern "c" fn pcre2_INFO_NAMECOUNT() -> UInt = "moonbit_pcre2_INFO_NAMECOUNT"

///|
extern "c" fn pcre2_INFO_NAMEENTRYSIZE() -> UInt = "moonbit_pcre2_INFO_NAMEENTRYSIZE"

///|
extern "c" fn pcre2_INFO_NAMETABLE() -> UInt = "moonbit_pcre2_INFO_NAMETABLE"

///|
extern "c" fn pcre2_INFO_NEWLINE() -> UInt = "moonbit_pcre2_INFO_NEWLINE"

///|
extern "c" fn pcre2_INFO_SIZE() -> UInt = "moonbit_pcre2_INFO_SIZE"

///|
extern "c" fn pcre2_pattern_info_16(
  code : Pcre2Code,
  what : UInt,
  where_ : @c.Pointer[Unit]
) -> Int = "pcre2_pattern_info_16"

///|
extern "c" fn pcre2_pattern_info_8(
  code : Pcre2Code,
  what : UInt,
  where_ : @c.Pointer[Unit]
) -> Int = "pcre2_pattern_info_8"

///|
priv enum Pcre2Newline {
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
fn pcre2_pattern_info_newline(code : Pcre2Code) -> Pcre2Newline {
  let newline = FixedArray::make(1, 0U)
  let _ = pcre2_pattern_info_16(
    code,
    pcre2_INFO_NEWLINE(),
    @c.Pointer::of_array(newline).cast(),
  )
  Pcre2Newline::of_uint(newline[0])
}

///|
fn pcre2_pattern_info_name_count(code : Pcre2Code) -> UInt {
  let name_count = FixedArray::make(1, 0U)
  let _ = pcre2_pattern_info_16(
    code,
    pcre2_INFO_NAMECOUNT(),
    @c.Pointer::of_array(name_count).cast(),
  )
  name_count[0]
}

///|
fn pcre2_pattern_info_name_table_16(code : Pcre2Code) -> @c.Pointer[UInt16] {
  let name_table = FixedArray::make(1, @c.null())
  let _ = pcre2_pattern_info_16(
    code,
    pcre2_INFO_NAMETABLE(),
    @c.Pointer::of_array(name_table).cast(),
  )
  name_table[0]
}

fn pcre2_pattern_info_name_table_8(code : Pcre2Code) -> @c.Pointer[Byte] {
  let name_table = FixedArray::make(1, @c.null())
  let _ = pcre2_pattern_info_8(
    code,
    pcre2_INFO_NAMETABLE(),
    @c.Pointer::of_array(name_table).cast(),
  )
  name_table[0]
}

///|
fn pcre2_pattern_info_name_entry_size(code : Pcre2Code) -> UInt {
  let name_entry_size = FixedArray::make(1, 0U)
  let _ = pcre2_pattern_info_16(
    code,
    pcre2_INFO_NAMEENTRYSIZE(),
    @c.Pointer::of_array(name_entry_size).cast(),
  )
  name_entry_size[0]
}
