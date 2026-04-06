cmake_minimum_required(VERSION 3.28)
project(cpp_cpm LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 20)

include(FetchContent)
FetchContent_Declare(
    cpm
    URL https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.40.2/CPM.cmake
    DOWNLOAD_NO_EXTRACT false
)
FetchContent_MakeAvailable(cpm)

CPMAddPackage("gh:nlohmann/json@3.11.3")
CPMAddPackage("gh:fmtlib/fmt#11.0.2")
CPMAddPackage("gh:gabime/spdlog@1.14.1")
CPMAddPackage("gh:jarro2783/cxxopts@3.2.1")
CPMAddPackage("gh:catchorg/Catch2@3.7.1")

add_executable(cpp_cpm main.cpp)
target_link_libraries(cpp_cpm PRIVATE nlohmann_json::nlohmann_json fmt::fmt spdlog::spdlog cxxopts::cxxopts Catch2::Catch2WithMain)
