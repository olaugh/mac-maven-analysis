# Host semantic reconstruction; this is not a classic Mac application build.
CC ?= cc
AR ?= ar
PYTHON ?= python3
BUILD_DIR ?= .build
CFLAGS ?= -O2 -g
CPPFLAGS += -Ireconstruction
WARNINGS = -std=c99 -Wall -Wextra -Werror
# The historical compiler probe has its own classic-Mac entry point and ABI.
SOURCES = $(filter-out reconstruction/toolchain_probe.c,$(wildcard reconstruction/*.c))
OBJECTS = $(patsubst reconstruction/%.c,$(BUILD_DIR)/%.o,$(SOURCES))

.PHONY: all check
all: $(BUILD_DIR)/libmaven-reconstruction.a $(BUILD_DIR)/word-enumerator

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/%.o: reconstruction/%.c | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(WARNINGS) -MMD -MP -c $< -o $@

$(BUILD_DIR)/libmaven-reconstruction.a: $(OBJECTS)
	$(AR) rcs $@ $(OBJECTS)

$(BUILD_DIR)/word-enumerator: scripts/word_enumerator_probe.c scripts/native_file_ops.h $(BUILD_DIR)/libmaven-reconstruction.a
	$(CC) $(CPPFLAGS) $(CFLAGS) $(WARNINGS) $< $(BUILD_DIR)/libmaven-reconstruction.a -o $@

check: all
	$(PYTHON) -m unittest discover -s tests

-include $(OBJECTS:.o=.d)
