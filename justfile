# Vulnetix manifest detection test harness

# Scan a single repo with dep count validation (expects entry in scripts/expected-counts.sh)
#   just scan-repo python-pipenv-lock
#   just scan-repo ruby-gemfile
scan-repo repo:
  @bash ./scripts/scan-single.sh {{repo}}

# Run vulnetix scan on all repos, report detection status + scanning success with summary
check-all:
  @bash ./scripts/check-all.sh

# Quick detection-only check for all repos
detect-all:
  @bash ./scripts/detect-all.sh

# List repos where vulnetix successfully scans
list-scannable:
  @bash ./scripts/list-scannable.sh

# Full real scan on all repos: validate manifest detection + direct dep count match + transitive deps > direct count
scan-all:
  @bash ./scripts/scan-all.sh

# Scan only repos that vulnetix actually supports (detected + resolvable), validate dep counts
# Much faster than scan-all — skips undetected and unsupported manifests
scan-supported:
  @bash ./scripts/scan-supported.sh

