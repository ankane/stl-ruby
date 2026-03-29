require "mkmf-rice"

$CXXFLAGS += " -std=c++20 $(optflags)"

create_makefile("stl/ext")
