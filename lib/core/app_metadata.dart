import 'constants/app_version.dart';

/// UI-facing version metadata backed by the release-generated constants.
///
/// `scripts/bump_version.py` refreshes [AppVersion] from `version.json`, so
/// release bumps flow into the UI automatically. One-off builds can override
/// the short label with `--dart-define=APP_VERSION=0.4.3` and the full label
/// with `--dart-define=APP_VERSION_FULL=0.4.3+32`.
const String appVersion = String.fromEnvironment(
  'APP_VERSION',
  defaultValue: AppVersion.semver,
);
const String appVersionFull = String.fromEnvironment(
  'APP_VERSION_FULL',
  defaultValue: AppVersion.version,
);
const String appVersionLabel = 'v$appVersion';
const String appVersionDisplay = 'Version $appVersionFull • Production Release';
