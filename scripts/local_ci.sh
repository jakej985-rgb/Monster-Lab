#!/usr/bin/env bash
set -e
export PATH="/opt/flutter/bin:$PATH"
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test --coverage
python3 scripts/validate_curriculum.py
