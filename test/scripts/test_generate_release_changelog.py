import contextlib
import importlib.util
import io
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
        self.pubspec.write_text("version: 0.2.0+25\n", encoding="utf-8")
        self.changelog.write_text(
            "# Changelog\n\n## [0.2.0+25] - 2026-10-11\n\nPrevious release.\n",
            encoding="utf-8",
        )
        self.path_patches = [
            mock.patch.object(release, "PUBSPEC_PATH", str(self.pubspec)),
            mock.patch.object(release, "CHANGELOG_PATH", str(self.changelog)),
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
        before = (self.pubspec.read_text(), self.changelog.read_text())
        with self.assertRaises(SystemExit) as error:
            self.run_main(*args)
        self.assertEqual(error.exception.code, 2)
        self.assertEqual((self.pubspec.read_text(), self.changelog.read_text()), before)

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

    def test_valid_bump_updates_pubspec_and_prepends_one_release(self):
        self.run_main("--apply", "--bump", "patch")
        self.assertIn("version: 0.2.1+26", self.pubspec.read_text())
        changelog = self.changelog.read_text()
        self.assertTrue(changelog.startswith("# Changelog\n\n## [0.2.1+26]"))
        self.assertEqual(changelog.count("## [0.2.1+26]"), 1)


if __name__ == "__main__":
    unittest.main()
