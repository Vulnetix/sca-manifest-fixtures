#include <fmt/core.h>
#include <spdlog/spdlog.h>
#include <nlohmann/json.hpp>

int main() {
    spdlog::info("Starting myapp");
    fmt::print("Hello from Conan!\n");
    nlohmann::json j = {{"status", "ok"}};
    fmt::print("{}\n", j.dump());
    return 0;
}
