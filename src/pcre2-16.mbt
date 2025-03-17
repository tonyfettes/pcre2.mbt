///|
extern "c" fn pcre2_get_error_message_16(
  errorcode : Int,
  buffer : String,
  bufflen : Pcre2Size
) -> Int = "pcre2_get_error_message_16"

///|
extern "c" fn pcre2_code_free_16(code : Pcre2Code) = "pcre2_code_free_16"

///|
extern "c" fn pcre2_compile_16(
  pattern : String,
  length : Int,
  options : UInt,
  errorcode : FixedArray[Int],
  erroroffset : FixedArray[Pcre2Size],
  context : @c.Nullable[Pcre2CompileContext]
) -> Pcre2Code = "pcre2_compile_16"

///|
extern "c" fn pcre2_match_data_create_from_pattern_16(
  code : Pcre2Code,
  context : @c.Nullable[Pcre2GeneralContext]
) -> Pcre2MatchData = "pcre2_match_data_create_from_pattern_16"

///|
extern "c" fn pcre2_match_data_free_16(match_data : Pcre2MatchData) = "pcre2_match_data_free_16"

///|
extern "c" fn pcre2_get_ovector_pointer_16(
  match_data : Pcre2MatchData
) -> @c.Pointer[Pcre2Size] = "pcre2_get_ovector_pointer_16"

///|
extern "c" fn pcre2_substitute_16(
  code : Pcre2Code,
  subject : String,
  length : Pcre2Size,
  start_offset : Int,
  options : UInt,
  match_data : Pcre2MatchData,
  mcontext : @c.Nullable[Pcre2MatchContext],
  replacement : String,
  rlength : Pcre2Size,
  outputbuffer : String,
  outlengthptr : FixedArray[Pcre2Size]
) -> Int = "pcre2_substitute_16"

///|
extern "c" fn pcre2_get_startchar_16(match_data : Pcre2MatchData) -> Pcre2Size = "pcre2_get_startchar_16"

///|
extern "c" fn pcre2_match_16(
  code : Pcre2Code,
  subject : String,
  length : Pcre2Size,
  start_offset : Pcre2Size,
  options : UInt,
  match_data : Pcre2MatchData,
  context : @c.Nullable[Pcre2MatchContext]
) -> Int = "pcre2_match_16"

///|
extern "c" fn pcre2_pattern_info_16(
  code : Pcre2Code,
  what : UInt,
  where_ : @c.Pointer[Unit]
) -> Int = "pcre2_pattern_info_16"
