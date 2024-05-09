# Dockerized C/CPP build/debug/run environment


## Usage

### Build images and apps for different architectures
* Release app build
```sh
./run.sh -a -amd64
./run.sh -a -arm64
```

* Debug app build
```sh
# Debug app build
./run.sh -ad -amd64
./run.sh -ad -arm64
```

* Production image build
```sh
# Debug app build
./run.sh -pb -amd64
./run.sh -pb -arm64
```

### Running the container
* Run Debug/Release app
```sh
./run.sh -ri -amd64
./run.sh -ri -arm64
```

* Run Debug/Release app under GDB server
```sh
# Debug app build
./run.sh -rig -amd64
./run.sh -rig -arm64

# To connect to the server please run:
gdb app/build/bin/my_project
(gdb) target remote localhost:2345
(gdb) c

# Demo:
# Stop execution
CTRL+C
# Set breakpoint
(gdb) break Game::updateStatusTextView
(gdb) set var m_score = 9999999
```

* Run production container
```sh
./run.sh -pr -amd64
./run.sh -pr -arm64
```

* Enter the dev container
```sh
./run.sh -s -amd64
./run.sh -s -arm64
```

### Static Code analysis
```sh
./run.sh -ca -amd64

# For CodeChecker server
./run.sh -s -amd64
# Inside the container
cmake --build build -t codechecker
# Goto http://localhost:8999/Default/runs
```

### Unitests
```sh
./run.sh -u -amd64
# UnitTests Report
firefox ~/Projects/cpp-project-template/app/build/test/unit/report/unit_tests_report.html
# Coverage Report
firefox ~/Projects/cpp-project-template/app/build/test/unit/report/coverage-report/index.html

# Run valgrind for the specific testcase
# Enter the container
./run.sh -s -amd64
# Inside the container
cmake --build build -t valgrind-ConfigReaderTest
```

### Fuzzing
```sh
./run.sh -f -amd64
```

### Memcheck (Valgrind)
```sh
# Build the app
./run.sh -ad -amd64
# Enter the container
./run.sh -s -amd64
# Inside the container
cmake --build build -t memcheck-my_project
# Memcheck  Report
firefox ~/Projects/cpp-project-template/app/build/memcheck_report/index.html
```

### Scanning the image and Linting the Dockerfile
```sh
./run.sh -sc
```

### Profiling
```sh
# Build the app in Debug mode
./run.sh -ad -amd64

# Run the app
./run.sh -ri -amd64

# Run the profiler client app and connect to port 28077
~/Projects/cpp-project-template/app/thirdparty/EasyProfiler/client_tools/easy_profiler-v2.1.0-linux/run_easy_profiler.sh
```


## Author
luk6xff

