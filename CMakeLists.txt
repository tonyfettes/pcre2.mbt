cmake_minimum_required(VERSION 3.19)
project(pcre2.mbt)

set(c.mbt_DIR ${CMAKE_SOURCE_DIR}/../c.mbt/install/lib/cmake/c.mbt)
find_package(c.mbt REQUIRED)

set(PCRE2_BUILD_PCRE2_16 ON)
add_subdirectory(src/pcre2 EXCLUDE_FROM_ALL)

# We need to include pcre2-16-static in the export set

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_VERBOSE_MAKEFILE on)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -fsanitize=address -Wmissing-field-initializers")

include(CMakePrintHelpers)
set(MOON_HOME "$ENV{MOON_HOME}")
cmake_print_variables(MOON_HOME)

include(cmake/moonbit.cmake)

setup_moonbit_module(.)

option(PCRE2_MBT_BUILD_TESTS "Build tests" OFF)

add_library(pcre2.mbt::moonbit ALIAS moonbit)

add_library(pcre2.mbt STATIC src/pcre2.c
  $<TARGET_OBJECTS:pcre2-16-static>)
add_library(pcre2.mbt::pcre2.mbt ALIAS pcre2.mbt)
target_link_libraries(pcre2.mbt
  PRIVATE c.mbt::c.mbt c.mbt::moonbit)

include(GNUInstallDirs)

install(
  TARGETS pcre2.mbt
  EXPORT pcre2.mbt-targets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(
  EXPORT pcre2.mbt-targets
  NAMESPACE pcre2.mbt::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/pcre2.mbt
  FILE pcre2.mbt-targets.cmake)
export(EXPORT pcre2.mbt-targets FILE ${CMAKE_CURRENT_BINARY_DIR}/pcre2.mbt-targets.cmake)
include(CMakePackageConfigHelpers)
configure_package_config_file(
  ${CMAKE_CURRENT_LIST_DIR}/cmake/config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/pcre2.mbt-config.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/pcre2.mbt
)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/pcre2.mbt-config.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/pcre2.mbt
)

if(PCRE2_MBT_BUILD_TESTS)
  add_moon_module(test)
endif()
