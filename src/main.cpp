#include <iostream>
#include <unistd.h>

#include "../headers/debugger.hpp"

auto main(int argc, char *argv[]) -> int {

    if (argc < 2) {
        std::cerr << "Program name not specified";
        return -1;
    }

    auto prog = argv[1];

    pid_t pid;

    // Ensure that the fork could be created
    try {
        pid = fork();

        if (pid < 0) {
            throw -1;
        }
    } catch (int e) {

        std::cout << "Fork could not be created" << std::endl;

        return -1;
    }

    if (pid == 0) {
        // We are in the child process
        // Execute the debugee
    }

    else if (pid >= 1) {
        // We are in the parent process
        // Execute the debugger
        std::cout << "Started debugging process " << pid << std::endl;
        Debugger dbg{prog, pid};
        dbg.run();
    }

    return 0;
}
