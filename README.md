# limit-memory
Script to manage cgroups for memory usage limitation (allows you to transfer the process only to SWAP)

## Usage: limit_memory.sh [--list | --add <PID> | --run <Command>]

- --list: Display the hierarchy of cgroups along with the processes in each group.
- --add <PID>: Add a process specified by its PID to the cgroup for memory usage limitation.
- --run <Command>: Run a new command and add its process to the cgroup for memory usage limitation.
