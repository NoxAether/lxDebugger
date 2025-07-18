#include "../headers/debugger.hpp"
#include "../headers/linenoise.h"
#include <iostream>
#include <sstream>
#include <sys/ptrace.h>
#include <sys/wait.h>

void Debugger::run() {

    // stores information on child status (enums from sys/wait.h)
    int wait_status;

    // pause the debugger process until child stops or exits
    auto options = 0;

    // wait for state change in in child
    waitpid(m_pid, &wait_status, options);

    char *line = nullptr;

    // continue getting input from linenoise until EOF (ctrl+d) is received
    while ((line = linenoise("minidbg> ")) != nullptr) {
        handle_command(line);
        linenoiseHistoryAdd(line);
        linenoiseFree(line);
    }
}

std::vector<std::string> Debugger::split(const std::string &s, char delimiter) {
    // stores the output of the split up string
    std::vector<std::string> out{};
    // used
    std::stringstream ss{s};
    std::string item;

    while (std::getline(ss, item, delimiter)) {
        out.push_back(item);
    }

    return out;
}

bool Debugger::is_prefix(const std::string &s, const std::string &of) {
    // return early if prefix is larger than string
    if (s.size() > of.size())
        return false;
    // compare chars in prefix and string
    return std::equal(s.begin(), s.end(), of.begin());
}

void Debugger::continue_execution() {
    // Continue execution and wait for a stop
    ptrace(PTRACE_CONT, m_pid, nullptr, nullptr);

    int wait_status;
    auto options = 0;
    waitpid(m_pid, &wait_status, options);
}

void Debugger::handle_command(const std::string &line) {
    auto args = split(line, ' ');
    auto command = args[0];

    if (is_prefix(command, "continue")) {
        continue_execution();
    }

    else {
        std::cerr << "Unknown command" << std::endl;
    }
}
