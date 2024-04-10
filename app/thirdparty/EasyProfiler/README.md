# EasyProfiler
## Version
[EasyProfiler github](https://github.com/yse/easy_profiler/releases) [[2.1.0]](https://github.com/yse/easy_profiler)

## About
Lightweight cross-platform profiler library for c++
Adapted for the project by: lukasz.uszko@gmail.com

## License
All the credists go to easy_profiler team.
Licensed under either of
- MIT license ([LICENSE.MIT](LICENSE.MIT) or http://opensource.org/licenses/MIT)
- Apache License, Version 2.0, ([LICENSE.APACHE](LICENSE.APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
at your option.

## Usage
Set build option `PROFILER_ENABLED` in a file: `MpicCamdriver/app/CMakeLists.txt`
```cpp
option(PROFILER_ENABLED "Enable profiling in the application" ON)
```

### Inserting blocks
```cpp
#include <profiler.h>

bool extractIr(const uint8_t *srcRaw, uint8_t *dstIr, ISplitRgbIr::AutoExposureGridStats& aeStats)
{
    EASY_FUNCTION(profiler::colors::Orange50);

    bool ret = false;
    if (m_isInitialized)
    {
        EASY_BLOCK("copyFrame(m_bufIr.src");
        copyFrame(m_bufIr.src, m_strideRgbIr, srcRaw, m_strideInOut, m_width);
        EASY_END_BLOCK;
        EASY_BLOCK("extract_IR");
        ret = (extract(m_bufIr, FrameType::IR) == 0);
        EASY_END_BLOCK;
        EASY_BLOCK("copyFrame(dstIr");
        copyFrame(dstIr, m_strideInOut, m_bufIr.dst, m_strideRgbIr, m_width);
        EASY_END_BLOCK;
        if (ret)
        {
            aeStats.grid = reinterpret_cast<uint32_t*>(m_bufIr.grid);
            aeStats.numOfGrids = m_aeNumOfGrids;
        }
    }
    return ret;
}

int main()
{
    EASY_PROFILER_ENABLE;
    profiler::startListen();
    /* do work */
    extractIr(...);
```

### Storing variables
```cpp
#include <profiler.h>
#include <arbitrary_value.h> // EASY_VALUE, EASY_ARRAY are defined here

class Object
{
    Vector3 m_position; // Let's suppose Vector3 is a struct { float x, y, z; };
    uint32_t m_id;
public:
    void foo()
    {
        EASY_FUNCTION(profiler::colors::Cyan);

        // Dump variables values
        constexpr auto Size = sizeof(Vector3) / sizeof(float);
        EASY_VALUE("id", m_id);
        EASY_ARRAY("position", &m_position.x, Size, profiler::color::Red);

        // Do something ...
    }

    void bar(uint32_t N)
    {
        EASY_FUNCTION();
        EASY_VALUE("N", N, EASY_VIN("N")); /* EASY_VIN is used here to ensure
                                            that this value id will always be
                                            the same, because the address of N
                                            can change */
        for (uint32_t i = 0; i < N; ++i)
        {
            // Do something
        }
    }
};

int main()
{
    EASY_PROFILER_ENABLE;
    profiler::startListen();
    /* do work */
    Object o;
    o.foo();
    o.bar();
}
```

### Dumping to file
1. (Profiled application) Start capturing by putting `EASY_PROFILER_ENABLE` macro somewhere into the code.
2. (Profiled application) Dump profiled data to file in any place you want by `profiler::dumpBlocksToFile("test_profile.prof")` function.
```cpp
int main() {
    EASY_PROFILER_ENABLE;
    /* do work */
    profiler::dumpBlocksToFile("test_profile.prof");
}
```

## Client App
### Windows
Extract `client_tools/easy_profiler-v2.1.0-win64.7z` and run `profiler_gui` app.
### Linux
Extract `client_tools/easy_profiler-v2.1.0-linux.tar.gz` and run `./run_easy_profiler.sh` script.
### Usage
1. (In profiled app) Invoke `profiler::startListen()`. This will start new thread to listen `28077` port for the start-capture-signal from profiler_gui.
2. (In UI) Connect profiler_gui to your application using `hostname` or `IP-address`.
3. (In UI) Press `Start capture` button in profiler_gui.
4. (In UI) Press `Stop capture` button in profiler_gui to stop capturing and wait until profiled data will be passed over network.
5. (Optional step)(In profiled app) Invoke `profiler::stopListen()` to stop listening.
