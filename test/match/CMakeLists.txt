add_moon_executable(match)
target_link_libraries(match PRIVATE pcre2.mbt::pcre2.mbt c.mbt::c.mbt pcre2-16-static)
