#include <boost/algorithm/string.hpp>
#include <spdlog/spdlog.h>
#include <fmt/core.h>
#include <openssl/ssl.h>
#include <catch2/catch_test_macros.hpp>

int main() {
    spdlog::info("Hello from cpp-conan test project");
    return 0;
}
