add_moon_executable(split)
target_link_libraries(split PRIVATE pcre2.mbt::pcre2.mbt c.mbt::c.mbt pcre2-16-static)
