CCPP=g++
CPPFLAGS=-c -Wall  -Wshadow -O2 -std=c++14
CFLAGS=-c -Wall -O2

LIBS=-lGLEW -lGL -lglfw
LDFLAGS=
DSFLAGS=-DNDEBUG

SOURCES= \
		src/gl_utils.cpp \
		src/parabola.cpp \
		src/args_parser.cpp \
		src/sdf_gl.cpp \
		src/glyph_painter.cpp \
		src/sdf_atlas.cpp \
		src/font.cpp \
		src/main.cpp

VPATH=$(dir $(SOURCES))

OBJECTS=$(addsuffix .o, $(basename $(SOURCES)))

BINDIR=./bin/
BINDEST=$(addprefix $(BINDIR), $(notdir $(OBJECTS)))

DEPNAMES = $(addsuffix .d, $(basename $(SOURCES)))
DEPS     = $(addprefix $(BINDIR), $(notdir $(DEPNAMES)))

EXECUTABLE=./bin/sdf_atlas

all: bindir $(EXECUTABLE)

$(EXECUTABLE): $(BINDEST)
	$(CCPP) $(LDFLAGS) $(BINDEST) $(LIBS) -o $@

$(BINDIR)%.o:%.cpp
	$(CCPP) $(CPPFLAGS) $(DSFLAGS) -MMD $< -o $(addprefix $(BINDIR), $(notdir $@))

.PHONY: all bindir clean

bindir:
	test -d $(BINDIR) || mkdir $(BINDIR)

clean:
	rm -f ./bin/*
	rm -f ./root/pre-merged.cpp root/merged.cpp root/merged.o

echo:
	@echo ${SOURCES} 

-include $(DEPS)

# Hack to get full implementation into a single source file for ROOT
# Uses this: git@github.com:osschar/cpp-merge.git

.PHONY: root/merged.cpp

root/merged.cpp:
	/opt/npm/bin/cpp-merge src/root_main.cpp > root/pre-merged.cpp
	perl -pi -e 'BEGIN { undef $$/; } $$_ =~ s!/\*.*?\*/!!goms;' root/pre-merged.cpp
#    perl -pi -e 's!^#include !// #include !o;' root/pre-merged.cpp
	perl -pi -e 's!^#include .*?\n!!o;' root/pre-merged.cpp
	cat root/preamble.h root/pre-merged.cpp root/postamble.h > root/merged.cpp
	rm root/pre-merged.cpp

root/merged.o: root/merged.cpp
	$(CCPP) $(CPPFLAGS) $(DSFLAGS) -MMD $< -o @$
