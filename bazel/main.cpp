#include <nlohmann/json.hpp>
#include "absl/strings/str_split.h"

int main() {
    nlohmann::json j = {{"message", "Hello from bazel test project"}};
    return 0;
}
