NAME := aoc2023
ASAN_NAME := asan
TEST_NAME := unit_tests

# ↓ Compilation configuration
CC := gcc -std=gnu11
CFLAGS := -W -Wall -Wextra -Wunused -Wpedantic
CFLAGS += -Wundef -Wshadow -Wcast-align
CFLAGS += -Wstrict-prototypes -Wmissing-prototypes
CFLAGS += -Waggregate-return -Wcast-qual
CFLAGS += -Wunreachable-code
CFLAGS += -U_FORTIFY_SOURCE
CFLAGS += -iquote ./.
LDFLAGS := -lm

# ↓ Sources
SRC := $(wildcard day*/source.c)

TEST_SRC := $(SRC)
TEST_SRC += tests.c

SRC += main.c

# ↓ Object files
BUILD_DIR := .build
OBJ := $(SRC:%.c=$(BUILD_DIR)/source/%.o)
ASAN_OBJ := $(SRC:%.c=$(BUILD_DIR)/asan/%.o)
TEST_OBJ := $(TEST_SRC:%.c=$(BUILD_DIR)/tests/%.o)

# ↓ Dependencies files
DEPS_FLAGS := -MMD -MP
DEPS := $(OBJ:.o=.d)
ASAN_DEPS := $(ASAN_OBJ:.o=.d)
TEST_DEPS := $(TEST_OBJ:.o=.d)


DEFAULT_GOAL := all
.PHONY: all
all: $(NAME)

# ↓ Compiling
$(BUILD_DIR)/source/%.o: %.c
	@ mkdir -p $(dir $@)
	$(CC) -o $@ -c $< $(CFLAGS) $(DEPS_FLAGS)

$(NAME): $(OBJ)
	$(CC) -o $@ $(OBJ) $(CFLAGS) $(LDFLAGS)


# ↓ Asan
$(BUILD_DIR)/asan/%.o: %.c
	@ mkdir -p $(dir $@)
	$(CC) -o $@ -c $< $(CFLAGS) $(DEPS_FLAGS)

$(ASAN_NAME): CFLAGS += -fsanitize=address,leak,undefined -g3
$(ASAN_NAME): $(ASAN_OBJ)
	$(CC) -o $@ $(ASAN_OBJ) $(CFLAGS) $(LDFLAGS)

$(BUILD_DIR)/tests/%.o: %.c
	@ mkdir -p $(dir $@)
	$(CC) -o $@ -c $< $(CFLAGS) $(DEPS_FLAGS)


# ↓ Unit tests
$(TEST_NAME): CFLAGS += -lcriterion -g3
$(TEST_NAME): $(TEST_OBJ)
	$(CC) -o $@ $(TEST_OBJ) $(CFLAGS) $(LDFLAGS)

.PHONY: tests_run
tests_run: fclean $(TEST_NAME)
	@ ./$(TEST_NAME)


# ↓ Cleaning
.PHONY: clean
clean:
	$(RM) $(OBJ) $(TEST_OBJ) $(ASAN_OBJ)

.PHONY: fclean
fclean: clean
	$(RM) $(NAME) $(TEST_NAME) $(ASAN_NAME)
	$(RM) -r $(BUILD_DIR)


# ↓ Meta
.PHONY: re
.NOTPARALLEL: re
re: fclean all

.PHONY: install
install: $(NAME)
	mkdir -p $(PREFIX)/bin
	install -m 755 $(NAME) $(PREFIX)/bin

-include $(DEPS)
-include $(ASAN_DEPS)
-include $(TEST_DEPS)
