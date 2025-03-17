#include <stdint.h>
#define PCRE2_CODE_UNIT_WIDTH 16
#include "pcre2-16/pcre2.h"
#include <moonbit.h>

#define static_assert_type_equal(type, expected)                               \
  _Static_assert(                                                              \
    _Generic((type)0, expected: 1, default: 0), #type " is not " #expected     \
  )

int32_t
moonbit_pcre2_ERROR_NOMATCH() {
  PCRE2_SPTR16 a;
  return PCRE2_ERROR_NOMATCH;
}

int32_t
moonbit_pcre2_ERROR_NOMEMORY() {
  return PCRE2_ERROR_NOMEMORY;
}

uint32_t
moonbit_pcre2_NOTEMPTY_ATSTART() {
  return PCRE2_NOTEMPTY_ATSTART;
}

uint32_t
moonbit_pcre2_ANCHORED() {
  return PCRE2_ANCHORED;
}

uint32_t
moonbit_pcre2_INFO_ALLOPTIONS() {
  return PCRE2_INFO_ALLOPTIONS;
}

uint32_t
moonbit_pcre2_INFO_ARGOPTIONS() {
  return PCRE2_INFO_ARGOPTIONS;
}

uint32_t
moonbit_pcre2_INFO_BACKREFMAX() {
  return PCRE2_INFO_BACKREFMAX;
}

uint32_t
moonbit_pcre2_INFO_BSR() {
  return PCRE2_INFO_BSR;
}

uint32_t
moonbit_pcre2_INFO_CAPTURECOUNT() {
  return PCRE2_INFO_CAPTURECOUNT;
}

uint32_t
moonbit_pcre2_INFO_DEPTHLIMIT() {
  return PCRE2_INFO_DEPTHLIMIT;
}

uint32_t
moonbit_pcre2_INFO_EXTRAOPTIONS() {
  return PCRE2_INFO_EXTRAOPTIONS;
}

uint32_t
moonbit_pcre2_INFO_FIRSTBITMAP() {
  return PCRE2_INFO_FIRSTBITMAP;
}

uint32_t
moonbit_pcre2_INFO_FIRSTCODETYPE() {
  return PCRE2_INFO_FIRSTCODETYPE;
}

uint32_t
moonbit_pcre2_INFO_FIRSTCODEUNIT() {
  return PCRE2_INFO_FIRSTCODEUNIT;
}

uint32_t
moonbit_pcre2_INFO_FRAMESIZE() {
  return PCRE2_INFO_FRAMESIZE;
}

uint32_t
moonbit_pcre2_INFO_HASBACKSLASHC() {
  return PCRE2_INFO_HASBACKSLASHC;
}

uint32_t
moonbit_pcre2_INFO_HASCRORLF() {
  return PCRE2_INFO_HASCRORLF;
}

uint32_t
moonbit_pcre2_INFO_HEAPLIMIT() {
  return PCRE2_INFO_HEAPLIMIT;
}

uint32_t
moonbit_pcre2_INFO_JCHANGED() {
  return PCRE2_INFO_JCHANGED;
}

uint32_t
moonbit_pcre2_INFO_JITSIZE() {
  return PCRE2_INFO_JITSIZE;
}

uint32_t
moonbit_pcre2_INFO_LASTCODETYPE() {
  return PCRE2_INFO_LASTCODETYPE;
}

uint32_t
moonbit_pcre2_INFO_LASTCODEUNIT() {
  return PCRE2_INFO_LASTCODEUNIT;
}

uint32_t
moonbit_pcre2_INFO_MATCHEMPTY() {
  return PCRE2_INFO_MATCHEMPTY;
}

uint32_t
moonbit_pcre2_INFO_MATCHLIMIT() {
  return PCRE2_INFO_MATCHLIMIT;
}

uint32_t
moonbit_pcre2_INFO_MAXLOOKBEHIND() {
  return PCRE2_INFO_MAXLOOKBEHIND;
}

uint32_t
moonbit_pcre2_INFO_NAMECOUNT() {
  return PCRE2_INFO_NAMECOUNT;
}

uint32_t
moonbit_pcre2_INFO_NAMEENTRYSIZE() {
  return PCRE2_INFO_NAMEENTRYSIZE;
}

uint32_t
moonbit_pcre2_INFO_NAMETABLE() {
  return PCRE2_INFO_NAMETABLE;
}

uint32_t
moonbit_pcre2_INFO_NEWLINE() {
  return PCRE2_INFO_NEWLINE;
}

uint32_t
moonbit_pcre2_INFO_SIZE() {
  return PCRE2_INFO_SIZE;
}

uint32_t
moonbit_pcre2_NEWLINE_CR() {
  return PCRE2_NEWLINE_CR;
}

uint32_t
moonbit_pcre2_NEWLINE_LF() {
  return PCRE2_NEWLINE_LF;
}

uint32_t
moonbit_pcre2_NEWLINE_CRLF() {
  return PCRE2_NEWLINE_CRLF;
}

uint32_t
moonbit_pcre2_NEWLINE_ANY() {
  return PCRE2_NEWLINE_ANY;
}

uint32_t
moonbit_pcre2_NEWLINE_ANYCRLF() {
  return PCRE2_NEWLINE_ANYCRLF;
}

uint32_t
moonbit_pcre2_NEWLINE_NUL() {
  return PCRE2_NEWLINE_NUL;
}

uint32_t
moonbit_pcre2_SUBSTITUTE_OVERFLOW_LENGTH() {
  return PCRE2_SUBSTITUTE_OVERFLOW_LENGTH;
}
