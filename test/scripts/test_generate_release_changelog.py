import contextlib
import importlib.util
import io
import json
import tempfile
import unittest
from pathlib import Path
from unittest import mock


SCRIPT_PATH = Path(__file__).resolve().parents[2] / "scripts" / "generate_release_changelog.py"
SPEC = importlib.util.spec_from_file_location("generate_release_changelog", SCRIPT_PATH)
release = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(release)


class ReleaseApplyValidationTests(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp_dir.cleanup)
        root = Path(self.temp_dir.name)
        self.pubspec = root / "pubspec.yaml"
        self.changelog = root / "CHANGELOG.md"
        self.dart_version = root / "lib" / "core" / "constants" / "app_version.dart"
        self.inno_setup = root / "windows" / "installer" / "monster_lab_setup.iss"
        self.runner_rc = root / "windows" / "runner" / "Runner.rc"
        self.dockerfile = root / "Dockerfile"
        self.version_json = root / "version.json"

        self.dart_version.parent.mkdir(parents=True, exist_ok=True)
        self.inno_setup.parent.mkdir(parents=True, exist_ok=True)
        self.runner_rc.parent.mkdir(parents=True, exist_ok=True)

        self.pubspec.write_text("version: 0.2.0+25\n", encoding="utf-8")
        self.changelog.write_text(
            "# Changelog\n\n## [0.2.0+25] - 2026-10-11\n\nPrevious release.\n",
            encoding="utf-8",
        )
        self.dart_version.write_text("class AppVersion { static const String version = '0.2.0+25'; }\n", encoding="utf-8")
        self.inno_setup.write_text('#define MyAppVersion "0.2.0"\n', encoding="utf-8")
        self.runner_rc.write_text('#define VERSION_AS_STRING "0.2.0"\n', encoding="utf-8")
        self.dockerfile.write_text('LABEL org.opencontainers.image.version="0.2.0"\n', encoding="utf-8")
        self.version_json.write_text(
            json.dumps(
                {
                    "version": "0.2.0",
                    "buildNumber": 25,
                    "packageMetadata": {
                        "android": {
                            "applicationId": "com.monsterlab.app",
                            "versionCode": 24,
                            "versionName": "0.1.0",
                        },
                        "docker": {"imageName": "monster-lab-web", "tag": "0.1.0"},
                    },
                },
                indent=2,
            )
            + "\n",
            encoding="utf-8",
        )

        self.path_patches = [
            mock.patch.object(release, "PUBSPEC_PATH", str(self.pubspec)),
            mock.patch.object(release, "CHANGELOG_PATH", str(self.changelog)),
            mock.patch.object(release, "DART_VERSION_PATH", str(self.dart_version)),
            mock.patch.object(release, "INNO_SETUP_PATH", str(self.inno_setup)),
            mock.patch.object(release, "RUNNER_RC_PATH", str(self.runner_rc)),
            mock.patch.object(release, "DOCKERFILE_PATH", str(self.dockerfile)),
            mock.patch.object(release, "VERSION_JSON_PATH", str(self.version_json)),
            mock.patch.object(release, "get_latest_tags", return_value=["v0.2.0"]),
            mock.patch.object(release, "get_commits_in_range", return_value=[]),
        ]
        for patcher in self.path_patches:
            patcher.start()
            self.addCleanup(patcher.stop)

    def run_main(self, *args, draft="## [0.2.1+26] - 2026-10-12\n\nRelease draft."):
        with mock.patch.object(release.sys, "argv", ["generate_release_changelog.py", *args]), \
             mock.patch.object(release, "generate_draft", return_value=draft), \
             contextlib.redirect_stdout(io.StringIO()), \
             contextlib.redirect_stderr(io.StringIO()):
            release.main()

    def assert_files_unchanged_after_error(self, args, expected_message):
        before = (
            self.pubspec.read_text(),
            self.changelog.read_text(),
            self.dart_version.read_text(),
            self.inno_setup.read_text(),
            self.runner_rc.read_text(),
            self.dockerfile.read_text(),
            self.version_json.read_text(),
        )
        with self.assertRaises(SystemExit) as error:
            self.run_main(*args)
        self.assertEqual(error.exception.code, 2)
        self.assertEqual(
            (
                self.pubspec.read_text(),
                self.changelog.read_text(),
                self.dart_version.read_text(),
                self.inno_setup.read_text(),
                self.runner_rc.read_text(),
                self.dockerfile.read_text(),
                self.version_json.read_text(),
            ),
            before,
        )

    def test_apply_requires_one_bump_or_version(self):
        self.assert_files_unchanged_after_error(("--apply",), "--apply")
        self.assert_files_unchanged_after_error(
            ("--apply", "--bump", "patch", "--version", "0.2.1"), "--apply"
        )

    def test_invalid_version_does_not_modify_either_file(self):
        self.assert_files_unchanged_after_error(
            ("--apply", "--version", "0.2"), "version"
        )

    def test_existing_release_section_is_rejected_before_writes(self):
        self.changelog.write_text(
            self.changelog.read_text() + "\n## [0.2.1+1] - 2026-10-12\nAlready released.\n",
            encoding="utf-8",
        )
        self.assert_files_unchanged_after_error(
            ("--apply", "--version", "0.2.1+2"), "release entry"
        )

    def test_parse_requested_version_supports_leading_v_and_preserves_current_build(self):
        semver, build = release.parse_requested_version("v0.2.0", current_build=25, current_semver="0.2.0")
        self.assertEqual((semver, build), ("0.2.0", 25))

        semver, build = release.parse_requested_version("v0.3.0", current_build=25, current_semver="0.2.0")
        self.assertEqual((semver, build), ("0.3.0", 26))

        semver, build = release.parse_requested_version("v0.3.0+99", current_build=25, current_semver="0.2.0")
        self.assertEqual((semver, build), ("0.3.0", 99))

    def test_valid_bump_updates_all_targets_and_prepends_one_release(self):
        self.run_main("--apply", "--bump", "patch")
        self.assertIn("version: 0.2.1+26", self.pubspec.read_text())
        self.assertIn("version = '0.2.1+26'", self.dart_version.read_text())
        self.assertIn('#define MyAppVersion "0.2.1"', self.inno_setup.read_text())
        self.assertIn('#define VERSION_AS_STRING "0.2.1"', self.runner_rc.read_text())
        self.assertIn('LABEL org.opencontainers.image.version="0.2.1"', self.dockerfile.read_text())
        manifest = json.loads(self.version_json.read_text())
        self.assertEqual(manifest["version"], "0.2.1")
        self.assertEqual(manifest["buildNumber"], 26)
        self.assertEqual(manifest["packageMetadata"]["android"]["versionCode"], 26)
        self.assertEqual(manifest["packageMetadata"]["android"]["versionName"], "0.2.1")
        self.assertEqual(manifest["packageMetadata"]["docker"]["tag"], "0.2.1")
        changelog = self.changelog.read_text()
        self.assertTrue(changelog.startswith("# Changelog\n\n## [0.2.1+26]"))
        self.assertEqual(changelog.count("## [0.2.1+26]"), 1)

    def test_generated_draft_strips_attribution_footers(self):
        commits = [
            {
                "sha": "abc1234",
                "subject": "fix(release): keep the manifest in sync",
                "body": (
                    "Sync package metadata during every bump.\n\n"
                    "🤖 Generated with Codebuff\n"
                    "Co-Authored-By: Codebuff <noreply@codebuff.com>"
                ),
            },
            {
                "sha": "def5678",
                "subject": "fix(release): footer only body",
                "body": "🤖 Generated with Codebuff\nCo-Authored-By: Codebuff <noreply@codebuff.com>",
            },
            {
                "sha": "aaa1111",
                "subject": "fix(release): devin trailer",
                "body": "Keep release notes clean.\n\nCo-Authored-By: Devin <devin@example.com>",
            },
        ]
        with mock.patch.object(release, "get_commits_in_range", return_value=commits):
            draft = release.generate_draft("0.2.1+26", "v0.2.0")

        self.assertIn("Sync package metadata during every bump.", draft)
        self.assertNotIn("Codebuff", draft)
        self.assertNotIn("Devin", draft)
        self.assertNotIn("Co-Authored-By", draft)
        self.assertNotIn("🤖", draft)
        self.assertIn("Implemented changes described in commit.", draft)

    def test_valid_version_with_leading_v_updates_all_targets(self):
        self.run_main("--apply", "--version", "v0.3.0+27")
        self.assertIn("version: 0.3.0+27", self.pubspec.read_text())
        self.assertIn("version = '0.3.0+27'", self.dart_version.read_text())
        self.assertIn('#define MyAppVersion "0.3.0"', self.inno_setup.read_text())
        self.assertIn('#define VERSION_AS_STRING "0.3.0"', self.runner_rc.read_text())
        self.assertIn('LABEL org.opencontainers.image.version="0.3.0"', self.dockerfile.read_text())
        manifest = json.loads(self.version_json.read_text())
        self.assertEqual(manifest["packageMetadata"]["android"]["versionCode"], 27)
        self.assertEqual(manifest["packageMetadata"]["android"]["versionName"], "0.3.0")
        self.assertEqual(manifest["packageMetadata"]["docker"]["tag"], "0.3.0")


if __name__ == "__main__":
    unittest.main()
