///|
priv extern type Pcre2Code

///|
priv extern type Pcre2CompileContext

///|
priv extern type Pcre2GeneralContext

///|
priv extern type Pcre2MatchData

///|
priv extern type Pcre2MatchContext

///|
typealias Pcre2Size = UInt64

///|
extern "c" fn pcre2_get_error_message(
  error_code : Int,
  buffer : String,
  buffer_length : Pcre2Size
) -> Int = "pcre2_get_error_message_16"

///|
extern "c" fn pcre2_code_free(code : Pcre2Code) = "pcre2_code_free_16"

///|
extern "c" fn pcre2_compile(
  pattern : String,
  length : Int,
  options : UInt,
  error_code : FixedArray[Int],
  error_offset : FixedArray[Pcre2Size],
  context : @c.Nullable[Pcre2CompileContext]
) -> Pcre2Code = "pcre2_compile_16"

///|
extern "c" fn pcre2_match_data_create_from_pattern(
  code : Pcre2Code,
  context : @c.Nullable[Pcre2GeneralContext]
) -> Pcre2MatchData = "pcre2_match_data_create_from_pattern_16"

///|
extern "c" fn pcre2_match_data_free(match_data : Pcre2MatchData) = "pcre2_match_data_free_16"

///|
extern "c" fn pcre2_get_ovector_pointer(
  match_data : Pcre2MatchData
) -> @c.Pointer[Pcre2Size] = "pcre2_get_ovector_pointer_16"

///|
extern "c" fn pcre2_substitute(
  code : Pcre2Code,
  subject : String,
  length : Pcre2Size,
  start_offset : Int,
  options : UInt,
  match_data : Pcre2MatchData,
  match_context : @c.Nullable[Pcre2MatchContext],
  replacement : String,
  replacement_length : Pcre2Size,
  output_buffer : String,
  output_length : FixedArray[Pcre2Size]
) -> Int = "pcre2_substitute_16"

///|
extern "c" fn pcre2_get_startchar(match_data : Pcre2MatchData) -> Pcre2Size = "pcre2_get_startchar_16"

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
extern "c" fn pcre2_pattern_info(
  code : Pcre2Code,
  what : UInt,
  where_ : @c.Pointer[Unit]
) -> Int = "pcre2_pattern_info_16"
