.PHONY: all genbuild delbuild build run clean install help sln docs

# see https://gist.github.com/sighingnow/deee806603ec9274fd47
# for details on the following snippet to get the OS
# (removed the flags about arch as it is not needed for now)
OSFLAG :=
ifeq ($(OS),Windows_NT)
	OSFLAG = WIN32
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		OSFLAG = LINUX
	endif
	ifeq ($(UNAME_S),Darwin)
		OSFLAG = OSX
	endif
endif

all: clean build run

genbuild:
ifeq ($(OSFLAG),WIN32)
	cmake . -B ./build -DCMAKE_TOOLCHAIN_FILE=D:/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_INSTALL_PREFIX=./install
else
	cmake . -B ./build -DCMAKE_TOOLCHAIN_FILE=${VCPKG_HOME}/scripts/buildsystems/vcpkg.cmake -DCMAKE_INSTALL_PREFIX=./install
endif

delbuild:
	rm -fR ./build

build:
	cmake --build ./build

buildrelease:
ifeq ($(OSFLAG),WIN32)
	cmake --build ./build --config Release
else
	echo "buildrelease make target is only supported on multi-config project types."
endif

clean:
	cmake --build ./build --target clean

install:
	cmake --build ./build --target install

sln:
ifeq ($(OSFLAG),WIN32)
	cygstart ".\build\v-rex-rl.sln"
else
	echo "No solution file available on this platform"
endif

help:
		@echo "********************************************************"
		@echo "  Makefile to build [v-rex-rl]"
		@echo "  (generated by gen-makefile.lua script)"
		@echo "********************************************************"
		@echo "  (The project uses CMake. This Makefile provides"
		@echo "   convenient shortcuts to common build tasks.)"
		@echo ""
		@echo "  all:           Runs the clean, build, and run targets."
		@echo "  build:         Runs the cmake project build target."
		@echo "  buildrelease:  Runs the cmake project release build target."
		@echo "  clean:         Runs the cmake project clean target."
		@echo "  install:       Runs the cmake project install target."
		@echo "  delbuild:      Deletes the cmake build directory!"
		@echo "  genbuild:      Generates the cmake build."
		@echo "  sln:           Generates the visual studio solution file."
		@echo "********************************************************"
