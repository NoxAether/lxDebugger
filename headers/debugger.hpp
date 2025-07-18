#ifndef DEBUGGER_H_
#define DEBUGGER_H_

#include <string>
#include <vector>

class Debugger {
  public:
    Debugger(std::string prog_name, pid_t pid)
        : m_prog_name{std::move(prog_name)}, m_pid{pid} {}

    // run the command loop
    void run();

    // handle user input
    void handle_command(const std::string &line);

    // UTILITY

    // split string by prefix
    std::vector<std::string> split(const std::string &s, char delimiter);

    // check if prefix
    bool is_prefix(const std::string &s, const std::string &of);

    // continue the execution
    void continue_execution();

  private:
    std::string m_prog_name;
    pid_t m_pid;
};

#endif // DEBUGGER_H_
