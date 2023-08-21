#!/bin/bash

# Usage: limit_memory.sh [--list | --add <PID> | --run <Command>]

# --list: Display the hierarchy of cgroups along with the processes in each group.
# --add <PID>: Add a process specified by its PID to the cgroup for memory usage limitation.
# --run <Command>: Run a new command and add its process to the cgroup for memory usage limitation.

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 [--list | --add <PID> | --run <Command>]"
    exit 1
fi

# Process command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --list)
            LIST_GROUPS=1
            ;;
        --add)
            ADD_PID="$2"
            shift
            ;;
        --run)
            RUN_COMMAND="$2"
            shift
            ;;
        *)
            echo "Invalid argument: $1"
            exit 1
            ;;
    esac
    shift
done

# Function to display cgroup hierarchy
display_hierarchy() {
    local dir="$1"
    local prefix="$2"
    local processes=$(cat "$dir/cgroup.procs" 2>/dev/null)

    echo "$prefix$dir ($processes)"
    for sub_dir in "$dir"/*; do
        if [ -d "$sub_dir" ]; then
            display_hierarchy "$sub_dir" "$prefix  "
        fi
    done
}

# Create cgroup directory
CGROUP_DIR="/sys/fs/cgroup/memory/example_group"
sudo mkdir -p "$CGROUP_DIR"

if [ -n "$LIST_GROUPS" ]; then
    echo "Cgroup Hierarchy:"
    display_hierarchy "$CGROUP_DIR" ""
elif [ -n "$ADD_PID" ]; then
    echo "$ADD_PID" | sudo tee "$CGROUP_DIR/cgroup.procs" > /dev/null
    echo "PID $ADD_PID added to the cgroup."
elif [ -n "$RUN_COMMAND" ]; then
    $RUN_COMMAND &
    new_pid=$!
    echo "$new_pid" | sudo tee "$CGROUP_DIR/cgroup.procs" > /dev/null
    echo "Command '$RUN_COMMAND' (PID: $new_pid) added to the cgroup."
fi
