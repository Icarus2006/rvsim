CC      = gcc
CFLAGS  = -std=c11 -Wall -Wextra -O2 -g
SRC     = $(wildcard src/*.c)
OBJ     = $(SRC:src/%.c=build/%.o)

all: rvsim

rvsim: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

build/%.o: src/%.c $(wildcard src/*.h) | build
	$(CC) $(CFLAGS) -c -o $@ $<

build:
	mkdir -p build

TEST_SRC = $(filter-out src/main.c, $(SRC))
test: build/test_unit
	./build/test_unit

build/test_unit: tests/unit/test_main.c $(TEST_SRC) | build
	$(CC) $(CFLAGS) -Isrc -o $@ $^

debug: CFLAGS = -std=c11 -Wall -Wextra -O0 -g -fsanitize=address,undefined
debug: clean rvsim

clean:
	rm -rf build rvsim

.PHONY: all test debug clean
