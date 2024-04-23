# filter_compile_commands.py
import json
import sys

def filter_compile_commands(input_file, output_file, excluded_dirs):
    # Load the existing compile commands
    with open(input_file, 'r') as infile:
        commands = json.load(infile)

    # Filter out commands based on excluded directories
    filtered_commands = [
        command for command in commands
        if not any(ex_dir in command['directory'] or ex_dir in command['file'] for ex_dir in excluded_dirs)
    ]

    # Write the filtered commands to a new file
    with open(output_file, 'w') as outfile:
        json.dump(filtered_commands, outfile, indent=2)

if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    excluded_dirs = sys.argv[3:]  # Multiple exclusion paths can be passed
    filter_compile_commands(input_file, output_file, excluded_dirs)
