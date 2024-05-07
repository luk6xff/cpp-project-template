#!/bin/bash

DIR_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

gdb $DIR_PATH/../build/bin/my_project

#(gdb) target remote localhost:2345
