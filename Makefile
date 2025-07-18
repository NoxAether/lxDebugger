CXX = g++

CC = gcc

BASE_CXXFLAGS = -Wall -Wextra -Iheaders/
BASE_CFLAGS = -Wall -Wextra -Iheaders/

OPT_CXXFLAGS = $(BASE_CXXFLAGS) -std=c++23 -O3 -DNDEBUG
OPT_CFLAGS = $(BASE_CFLAGS) -std=c23 -O3 -DNDEBUG

DEBUG_CXXFLAGS = $(BASE_CXXFLAGS) -std=c++23 -O0 -g
DEBUG_CFLAGS = $(BASE_CFLAGS) -std=c23 -O0 -g

LDFLAGS =

BIN = bin

TARGET_OPT = $(BIN)/lxDebugger_opt
TARGET_DEBUG = $(BIN)/lxDebugger_debug

SRCDIR = src

OBJDIR = obj
OBJDIR_OPT = $(OBJDIR)/opt
OBJDIR_DEBUG = $(OBJDIR)/debug

DEPDIR = .deps
DEPDIR_OPT = $(DEPDIR)/opt
DEPDIR_DEBUG = $(DEPDIR)/debug

CXX_SOURCES = $(wildcard $(SRCDIR)/*.cpp)
C_SOURCES = $(wildcard $(SRCDIR)/*.c)

CXX_OBJECTS_OPT = $(patsubst $(SRCDIR)/%.cpp,$(OBJDIR_OPT)/%.o,$(CXX_SOURCES))
C_OBJECTS_OPT = $(patsubst $(SRCDIR)/%.c,$(OBJDIR_OPT)/%.o,$(C_SOURCES))
OBJECTS_OPT = $(CXX_OBJECTS_OPT) $(C_OBJECTS_OPT)

CXX_OBJECTS_DEBUG = $(patsubst $(SRCDIR)/%.cpp,$(OBJDIR_DEBUG)/%.o,$(CXX_SOURCES))
C_OBJECTS_DEBUG = $(patsubst $(SRCDIR)/%.c,$(OBJDIR_DEBUG)/%.o,$(C_SOURCES))
OBJECTS_DEBUG = $(CXX_OBJECTS_DEBUG) $(C_OBJECTS_DEBUG)

.PHONY: all
all: $(TARGET_OPT) $(TARGET_DEBUG)
	@rm -rf $(OBJDIR)

$(TARGET_OPT): $(OBJECTS_OPT)
	@mkdir -p $(BIN)
	$(CXX) $(OBJECTS_OPT) -o $@ $(LDFLAGS)

$(TARGET_DEBUG): $(OBJECTS_DEBUG)
	@mkdir -p $(BIN)
	$(CXX) $(OBJECTS_DEBUG) -o $@ $(LDFLAGS)

$(OBJDIR_OPT)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(OPT_CXXFLAGS) -c $< -o $@

$(OBJDIR_OPT)/%.o: $(SRCDIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(OPT_CFLAGS) -c $< -o $@

$(OBJDIR_DEBUG)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(DEBUG_CXXFLAGS) -c $< -o $@

$(OBJDIR_DEBUG)/%.o: $(SRCDIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(DEBUG_CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(OBJDIR) $(BIN) $(DEPDIR)
	@echo "Clean complete."

$(shell mkdir -p $(DEPDIR_OPT) >/dev/null)
$(shell mkdir -p $(DEPDIR_DEBUG) >/dev/null)

-include $(patsubst $(SRCDIR)/%.cpp,$(DEPDIR_OPT)/%.d,$(CXX_SOURCES))
-include $(patsubst $(SRCDIR)/%.c,$(DEPDIR_OPT)/%.d,$(C_SOURCES))
-include $(patsubst $(SRCDIR)/%.cpp,$(DEPDIR_DEBUG)/%.d,$(CXX_SOURCES))
-include $(patsubst $(SRCDIR)/%.c,$(DEPDIR_DEBUG)/%.d,$(C_SOURCES))

$(OBJDIR_OPT)/%.o: $(SRCDIR)/%.cpp | $(DEPDIR_OPT)/%.d
$(DEPDIR_OPT)/%.d: $(SRCDIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(OPT_CXXFLAGS) -MMD -MP -MF $@ $<

$(OBJDIR_OPT)/%.o: $(SRCDIR)/%.c | $(DEPDIR_OPT)/%.d
$(DEPDIR_OPT)/%.d: $(SRCDIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(OPT_CFLAGS) -MMD -MP -MF $@ $<

$(OBJDIR_DEBUG)/%.o: $(SRCDIR)/%.cpp | $(DEPDIR_DEBUG)/%.d
$(DEPDIR_DEBUG)/%.d: $(SRCDIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(DEBUG_CXXFLAGS) -MMD -MP -MF $@ $<

$(OBJDIR_DEBUG)/%.o: $(SRCDIR)/%.c | $(DEPDIR_DEBUG)/%.d
$(DEPDIR_DEBUG)/%.d: $(SRCDIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(DEBUG_CFLAGS) -MMD -MP -MF $@ $<
