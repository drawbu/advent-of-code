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
LDFLAGS :=

# ↓ Sources
SRC := day01/source.c
SRC += day02/source.c

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

# ↓ Compiling
$(BUILD_DIR)/source/%.o: %.c
	@ mkdir -p $(dir $@)
	$(CC) -o $@ -c $< $(CFLAGS) $(DEPS_FLAGS)

$(NAME): $(OBJ)
	$(CC) -o $@ $(OBJ) $(CFLAGS) $(LDFLAGS)

.PHONY: $(NAME)

# ↓ Asan
$(BUILD_DIR)/asan/%.o: %.c
	@ mkdir -p $(dir $@)
	$(CC) -o $@ -c $< $(CFLAGS) $(DEPS_FLAGS)

$(ASAN_NAME): CFLAGS += -fsanitize=address,leak,undefined -g3
$(ASAN_NAME): $(ASAN_OBJ)
	$(CC) -o $@ $(ASAN_OBJ) $(CFLAGS) $(LDFLAGS)

.PHONY: $(ASAN_NAME)

# ↓ Unit tests
$(BUILD_DIR)/tests/%.o: %.c
	@ mkdir -p $(dir $@)
	$(CC) -o $@ -c $< $(CFLAGS) $(DEPS_FLAGS)

$(TEST_NAME): CFLAGS += -lcriterion -g3
$(TEST_NAME): $(TEST_OBJ)
	$(CC) -o $@ $(TEST_OBJ) $(CFLAGS) $(LDFLAGS)

tests_run: fclean $(TEST_NAME)
	@ ./$(TEST_NAME)

.PHONY: $(TEST_NAME) tests_run

# ↓ Cleaning
clean:
	$(RM) $(OBJ) $(TEST_OBJ) $(ASAN_OBJ)

fclean: clean
	$(RM) $(NAME) $(TEST_NAME) $(ASAN_NAME)
	$(RM) -r $(BUILD_DIR)

.PHONY: clean fclean

re: fclean
	@ $(MAKE) -s -C .

.PHONY: re

-include $(DEPS)
-include $(ASAN_DEPS)
-include $(TEST_DEPS)
