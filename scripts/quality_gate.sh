#!/usr/bin/env bash
# ==============================================================================
# Monster Lab - Unified Quality Gate Runner
# Enforces mandatory quality checks across:
# 1. Dart code formatting
# 2. Static analysis (zero warnings/errors)
# 3. Automated unit and widget tests
# 4. Repo-wide line coverage threshold (>= 80%)
# 5. Secret & sensitive pattern scan
# 6. Dependency integrity and security scan
# 7. Curriculum data validation and JSON schema checks
# 8. Canonical version manifest synchronization
# 9. Release artifact specification checks (Android, Linux, Windows, Docker)
# 10. Changelog footer hygiene (no assistant attribution trailers)
# 11. Python release-tool unit tests
# ==============================================================================

set -euo pipefail

export PATH="/opt/flutter/bin:$PATH"

echo "================================================================="
echo "                MONSTER LAB - QUALITY GATE RUNNER                "
echo "================================================================="

echo "[1/11] Checking Dart code formatting..."
dart format --output=none --set-exit-if-changed .
echo "  Format check: PASSED"

echo "[2/11] Running static analyzer..."
flutter analyze
echo "  Static analysis: PASSED"

echo "[3/11] Executing automated test suite with coverage..."
flutter test --coverage
echo "  Test suite: PASSED"

echo "[4/11] Verifying code coverage threshold..."
python3 scripts/verify_coverage.py --threshold 80.0
echo "  Coverage gate: PASSED"

echo "[5/11] Scanning for exposed secrets..."
python3 scripts/scan_secrets.py
echo "  Secret scan: PASSED"

echo "[6/11] Scanning dependencies for vulnerabilities..."
python3 scripts/scan_dependencies.py
echo "  Dependency scan: PASSED"

echo "[7/11] Validating curriculum schema and asset integrity..."
python3 scripts/validate_curriculum.py
echo "  Curriculum validation: PASSED"

echo "[8/11] Verifying release version synchronization..."
python3 scripts/verify_version_sync.py
echo "  Version sync: PASSED"

echo "[9/11] Verifying multi-platform release artifacts..."
python3 scripts/verify_release_artifacts.py
echo "  Release artifacts: PASSED"

echo "[10/11] Verifying changelog footer hygiene..."
python3 scripts/verify_changelog_hygiene.py
echo "  Changelog hygiene: PASSED"

echo "[11/11] Running release and lesson tool unit tests..."
python3 -m unittest discover -s test/scripts -p 'test_generate_release_*.py'
python3 -m unittest discover -s test/scripts -p 'test_*lesson*.py'
echo "  Release and lesson tool tests: PASSED"

echo "================================================================="
echo "[SUCCESS] ALL QUALITY GATES PASSED! READY FOR RELEASE."
echo "================================================================="
