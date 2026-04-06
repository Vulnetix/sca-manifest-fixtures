cmake_minimum_required(VERSION 3.15)
project(myapp CXX)

set(CMAKE_CXX_STANDARD 17)

find_package(Boost REQUIRED)
find_package(fmt REQUIRED)
find_package(spdlog REQUIRED)
find_package(nlohmann_json REQUIRED)
find_package(Catch2 REQUIRED)

add_executable(myapp main.cpp)
target_link_libraries(myapp
    Boost::boost
    fmt::fmt
    spdlog::spdlog
    nlohmann_json::nlohmann_json
)
