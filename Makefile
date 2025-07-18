CXX = g++

CC = gcc

CXXFLAGS = -Wall -Wextra -std=c++23 -g -Iheaders/

CFLAGS = -Wall -Wextra -std=c23 -g -Iheaders/

LDFLAGS =

TARGET = $(BIN)/lxDebugger

SRCDIR = src

OBJDIR = obj

BIN = bin

CXX_SOURCES = $(wildcard $(SRCDIR)/*.cpp)

C_SOURCES = $(wildcard $(SRCDIR)/*.c)

CXX_OBJECTS = $(patsubst $(SRCDIR)/%.cpp,$(OBJDIR)/%.o,$(CXX_SOURCES))
C_OBJECTS = $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(C_SOURCES))
OBJECTS = $(CXX_OBJECTS) $(C_OBJECTS)

.PHONY: all
all: $(TARGET)

$(TARGET): $(OBJECTS)
	@mkdir -p $(@D)
	$(CXX) $(OBJECTS) -o $@ $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(OBJDIR) $(TARGET) $(DEPDIR)
	@echo "Clean complete."

DEPDIR = .deps
$(shell mkdir -p $(DEPDIR) >/dev/null)

-include $(patsubst $(SRCDIR)/%.cpp,$(DEPDIR)/%.d,$(CXX_SOURCES))
-include $(patsubst $(SRCDIR)/%.c,$(DEPDIR)/%.d,$(C_SOURCES))

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp | $(DEPDIR)/%.d
$(DEPDIR)/%.d: $(SRCDIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -MMD -MP -MF $@ $<

$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(DEPDIR)/%.d
$(DEPDIR)/%.d: $(SRCDIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -MMD -MP -MF $@ $<
