#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>
#include <unistd.h>

#define NUM_RUNS 5

typedef struct {
    const char* command;
    double* time;
} CommandInfo;

void* execute_command(void* arg) {
    CommandInfo* cmd_info = (CommandInfo*)arg;
    clock_t start = clock();
    int result = system(cmd_info->command);
    clock_t end = clock();
    if (result != 0) {
        printf("Error running command: %s\n", cmd_info->command);
        exit(EXIT_FAILURE);
    }
    *cmd_info->time = ((double)(end - start)) / CLOCKS_PER_SEC;
    return NULL;
}

int main() {
    const char* commands[] = {
        "gcc C/C.c -o C/C",                // C
        "g++ C++/CPP.cpp -o C++/CPP",      // C++
        "python Python3/python3.py",      // Python 3
        "node JavaScript/javascript.js",   // JavaScript (Node.js)
        "javac Java/Java.java",            // Java
        "go run Go/Go.go",                 // Go
        "rustc Rust/Rust.rs -o Rust/rust", // Rust
        "dotnet run --project C#",         // C#
        "kotlinc Kotlin/Kotlin.kt -include-runtime -d Kotlin/Kotlin.jar", // Kotlin
        "php Php/Php.php",                  // PHP
        "ruby Ruby/Ruby.rb",                 // Ruby
        "runghc Haskell/Haskell.hs",         // Haskell
        "perl Perl/Perl.pl",                  // Perl
        "dmd D/dd.d -ofD/dd",                  // D
        "Rscript R/R.r",                 // R
        "lua Lua/Lua.lua",                 // Lua
    };

    const char* languages[] = {
        "C",
        "C++",
        "Python",
        "JavaScript",
        "Java",
        "Go",
        "Rust",
        "C#",
        "Kotlin",
        "PHP",
        "Ruby",
        "Haskell",
        "Perl",
        "D",
        "R",
        "Lua",
    };

    int num_commands = sizeof(commands) / sizeof(commands[0]);
    int num_cores = 8;

    for (int i = 0; i < num_commands; i += num_cores) {
        pthread_t threads[num_cores];
        CommandInfo cmd_info[num_cores];
        double time_results[num_cores];

        for (int j = 0; j < num_cores && (i + j) < num_commands; j++) {
            cmd_info[j].command = commands[i + j];
            cmd_info[j].time = &time_results[j];
            pthread_create(&threads[j], NULL, execute_command, &cmd_info[j]);
        }

        for (int j = 0; j < num_cores && (i + j) < num_commands; j++) {
            pthread_join(threads[j], NULL);
        }

        for (int j = 0; j < num_cores && (i + j) < num_commands; j++) {
            printf("Time for %s: %.6f seconds\n", languages[i + j], time_results[j]);
        }
    }

    printf("total bahasa yang di benchmark : %d\n", num_commands);

    return 0;
}