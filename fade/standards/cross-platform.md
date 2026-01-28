# Cross-Platform Development Standard

Guidelines for building applications that work on macOS, Linux, and Windows. Apply these principles when designing multi-platform systems.

---

## The Cross-Platform Challenge

Software designed for Unix-like systems (macOS, Linux) often requires significant rework for Windows due to fundamental differences in:
- Process management and IPC
- File system conventions
- Shared memory APIs
- Build tooling

**Why it matters:**
- Windows represents a large enterprise market
- Cross-platform support expands user base
- Retrofitting Windows support is expensive
- Design decisions made early determine portability

---

## Design Principles

### 1. **Platform Abstraction Layers**

Abstract platform-specific code behind interfaces.

```cpp
// Bad - Platform-specific code scattered throughout
#ifdef _WIN32
  HANDLE h = CreateFileMapping(...);
#else
  int fd = shm_open(...);
#endif

// Good - Abstraction hides platform differences
class SharedMemory {
public:
  SharedMemory(const std::string& name, size_t size);
  void* get_ptr();
  ~SharedMemory();
private:
  #ifdef _WIN32
    HANDLE handle;
  #else
    int fd;
  #endif
};

// Usage is identical on all platforms
SharedMemory shm("mydata", 1024);
void* ptr = shm.get_ptr();
```

**Apply to:**
- Shared memory / IPC
- Process spawning
- File locking
- Threading primitives

### 2. **Use Cross-Platform Libraries**

Prefer battle-tested libraries over platform-specific APIs.

| Task | Cross-Platform Library | Avoid |
|------|----------------------|-------|
| Build system | CMake, Meson | Makefiles only |
| File paths | `std::filesystem` (C++17), `pathlib` (Python) | String concatenation |
| Process management | Boost.Process, subprocess (Python) | `fork/exec`, `CreateProcess` |
| Threading | `std::thread`, `threading` (Python) | `pthread`, Win32 threads |
| Networking | Boost.Asio, `socket` (Python) | Raw sockets |
| JSON parsing | nlohmann/json, `json` (Python) | Custom parsers |

```python
# Bad - Platform-specific paths
data_file = "/home/user/data.csv"  # Fails on Windows

# Good - Cross-platform paths
from pathlib import Path
data_file = Path.home() / "data.csv"  # Works everywhere
```

### 3. **Configuration Over Convention**

Don't assume Unix conventions.

```python
# Bad - Assumes Unix paths
config = {
  "data_dir": "/var/lib/myapp",
  "log_file": "/var/log/myapp.log"
}

# Good - Platform-appropriate defaults
import os
from pathlib import Path

def get_default_data_dir():
  if os.name == 'nt':  # Windows
    return Path(os.environ['APPDATA']) / 'MyApp'
  else:  # Unix-like
    return Path.home() / '.local' / 'share' / 'myapp'

config = {
  "data_dir": os.getenv("MYAPP_DATA_DIR", get_default_data_dir()),
  "log_file": ...
}
```

### 4. **Test on Target Platforms Early**

Don't wait until the end to test Windows support.

**Strategies:**
- Use VMs (Parallels, VirtualBox) for periodic testing
- Set up CI/CD with Windows runners (GitHub Actions)
- Use Docker with Windows containers (requires Windows host)

```yaml
# GitHub Actions: Test on multiple platforms
jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: pytest tests/
```

---

## Language-Specific Guidelines

### Python

✅ **Naturally Cross-Platform**
- Standard library designed for portability
- `pathlib`, `subprocess`, `threading` work everywhere
- Virtual environments isolate dependencies

⚠️ **Watch For:**
- Native extensions (C/C++ modules) need compilation on Windows
- File permissions (`chmod`, `os.umask`) differ on Windows
- Signal handling (SIGTERM works differently on Windows)

```python
# Bad - Unix-specific signal handling
import signal
signal.signal(signal.SIGTERM, handler)  # SIGTERM not available on Windows

# Good - Cross-platform signal handling
import signal
import sys

if sys.platform == 'win32':
  # Windows: Handle CTRL+C and CTRL+BREAK
  signal.signal(signal.SIGINT, handler)
  signal.signal(signal.SIGBREAK, handler)
else:
  # Unix: Handle standard signals
  signal.signal(signal.SIGTERM, handler)
  signal.signal(signal.SIGINT, handler)
```

### C/C++

⚠️ **Requires Explicit Portability Effort**

**Build System:** Use CMake

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.15)
project(MyApp)

set(CMAKE_CXX_STANDARD 17)

# Platform-specific source files
if(WIN32)
  set(PLATFORM_SOURCES src/windows/ipc_win.cpp)
else()
  set(PLATFORM_SOURCES src/unix/ipc_unix.cpp)
endif()

add_executable(myapp
  src/main.cpp
  src/shared_logic.cpp
  ${PLATFORM_SOURCES}
)

# Platform-specific libraries
if(WIN32)
  target_link_libraries(myapp ws2_32)  # Winsock
else()
  target_link_libraries(myapp pthread)
endif()
```

**File Paths:** Use `std::filesystem`

```cpp
#include <filesystem>
namespace fs = std::filesystem;

// Good - Cross-platform paths
fs::path config_file = fs::current_path() / "config.json";
std::ifstream file(config_file);  // Works on all platforms
```

**Shared Memory:** Abstract platform APIs

```cpp
// shared_memory.h
class SharedMemory {
public:
  SharedMemory(const std::string& name, size_t size);
  void* map();
  void unmap();
  ~SharedMemory();

private:
  #ifdef _WIN32
    HANDLE file_mapping_;
    void* mapped_view_;
  #else
    int fd_;
    void* mapped_ptr_;
    size_t size_;
  #endif
  std::string name_;
};
```

### JavaScript/Node.js

✅ **Highly Portable**
- Node.js runtime is cross-platform
- `path`, `fs`, `child_process` handle platform differences

⚠️ **Watch For:**
- Shell commands in `child_process.exec()` (cmd.exe vs bash)
- Native modules (need compilation on Windows)

```javascript
// Bad - Assumes Unix shell
const { exec } = require('child_process');
exec('ls -la', callback);  // Fails on Windows

// Good - Use Node.js APIs
const fs = require('fs').promises;
const files = await fs.readdir('.');

// If shell commands needed, detect platform
const isWindows = process.platform === 'win32';
const listCmd = isWindows ? 'dir' : 'ls -la';
exec(listCmd, callback);
```

---

## Common Pitfalls

### 1. **Hardcoded Paths**

❌ **Bad:**
```python
DATA_DIR = "/opt/myapp/data"
LOG_FILE = "/var/log/myapp.log"
```

✅ **Good:**
```python
from pathlib import Path
import os

DATA_DIR = Path(os.getenv("MYAPP_DATA_DIR",
                Path.home() / ".myapp" / "data"))
LOG_FILE = Path(os.getenv("MYAPP_LOG_FILE",
                Path.home() / ".myapp" / "logs" / "myapp.log"))
```

### 2. **Unix-Only Process Management**

❌ **Bad:**
```cpp
pid_t pid = fork();
if (pid == 0) {
  execvp(cmd, args);  // Child process
}
// Windows doesn't have fork()
```

✅ **Good:**
```cpp
// Use Boost.Process (cross-platform)
#include <boost/process.hpp>
namespace bp = boost::process;

bp::child c(bp::search_path("python"), "script.py");
c.wait();
```

### 3. **Assuming Unix Signals**

❌ **Bad:**
```python
import signal
signal.signal(signal.SIGHUP, reload_config)  # SIGHUP doesn't exist on Windows
```

✅ **Good:**
```python
# Use file watching or polling instead
from watchdog.observers import Observer
observer = Observer()
observer.schedule(event_handler, config_path)
observer.start()
```

### 4. **Shell Script Dependencies**

❌ **Bad:**
```python
subprocess.run(["grep", "-r", "pattern", "files/"])  # grep not on Windows
```

✅ **Good:**
```python
# Use Python libraries instead of shell commands
import pathlib

def search_files(pattern, directory):
  for file in pathlib.Path(directory).rglob("*"):
    if file.is_file():
      with open(file) as f:
        if pattern in f.read():
          yield file
```

---

## Testing Strategy

### Local Testing (Development)

1. **Primary Platform:** Develop on your main OS (macOS/Linux)
2. **Periodic Testing:** Test on Windows VM weekly
3. **Integration Testing:** Full test suite on all platforms before release

### CI/CD Testing (Automated)

```yaml
# .github/workflows/test.yml
name: Cross-Platform Tests

on: [push, pull_request]

jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        python-version: ['3.9', '3.10', '3.11']
    runs-on: ${{ matrix.os }}

    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Run tests
        run: pytest tests/ -v

      - name: Run platform-specific tests
        run: pytest tests/platform/ -v
```

### Platform-Specific Test Directories

```
tests/
├── test_core.py           # Cross-platform tests
├── test_api.py            # Cross-platform tests
├── platform/
│   ├── test_unix.py       # Unix-only tests (skipped on Windows)
│   ├── test_windows.py    # Windows-only tests (skipped on Unix)
│   └── test_ipc.py        # Platform abstraction tests (runs everywhere)
```

```python
# Platform-specific test skipping
import pytest
import sys

@pytest.mark.skipif(sys.platform != 'win32', reason="Windows-only test")
def test_windows_specific_feature():
  # Test Windows-specific code
  pass

@pytest.mark.skipif(sys.platform == 'win32', reason="Unix-only test")
def test_unix_specific_feature():
  # Test Unix-specific code
  pass
```

---

## Architecture Checklist

Use this checklist when designing new features:

- [ ] **File Paths:** Use `pathlib` (Python) or `std::filesystem` (C++)
- [ ] **Build System:** CMake or platform-agnostic build tool
- [ ] **IPC/Shared Memory:** Abstract behind platform-agnostic interface
- [ ] **Process Management:** Use cross-platform libraries (Boost.Process, subprocess)
- [ ] **Configuration:** Detect platform, use appropriate defaults
- [ ] **Dependencies:** All dependencies available on target platforms
- [ ] **Testing:** CI/CD tests on all platforms
- [ ] **Documentation:** Note platform-specific behavior and limitations

---

## When to Read This Standard

Read this document when:
- Starting a new project that may need Windows support
- Designing IPC or shared memory systems
- Writing file I/O or path manipulation code
- Setting up build systems (CMake, Makefiles)
- Receiving bug reports from Windows users
- Planning cross-platform deployment

---

## References

- [CMake Documentation](https://cmake.org/documentation/)
- [C++ Filesystem Library](https://en.cppreference.com/w/cpp/filesystem)
- [Python pathlib](https://docs.python.org/3/library/pathlib.html)
- [Boost.Process](https://www.boost.org/doc/libs/release/doc/html/process.html)
- [GitHub Actions: Multiple Platforms](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idruns-on)
