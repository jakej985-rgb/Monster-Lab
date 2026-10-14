import importlib.util
import tempfile
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).resolve().parents[2] / "scripts" / "generate_lesson_pdf.py"
SPEC = importlib.util.spec_from_file_location("generate_lesson_pdf", SCRIPT_PATH)
generator = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(generator)


def activity(title, learner_rows, educator_rows):
    return {
        "title": title,
        "simulationName": "sharedWidget",
        "instructions": "Record your observations.",
        "table": {
            "headers": ["Step", "Observation"],
            "learnerRows": learner_rows,
            "educatorRows": educator_rows,
        },
    }


class PrintableActivityExportTests(unittest.TestCase):
    def render(self, lesson, mode):
        temp_dir = tempfile.TemporaryDirectory()
        self.addCleanup(temp_dir.cleanup)
        output = Path(temp_dir.name) / "lesson.html"
        generator.render_lesson_to_html(lesson, str(output), mode=mode)
        return output.read_text(encoding="utf-8")

    def test_learner_export_hides_answers_and_educator_export_includes_them(self):
        lesson = {
            "id": "worksheet_test",
            "title": "Worksheet test",
            "steps": [{
                "stepId": "s1",
                "interactiveWidgetType": "sharedWidget",
                "interactiveConfig": {
                    "printableActivity": activity(
                        "Student Activity",
                        [["220 ohms", "&nbsp;"]],
                        [["220 ohms", "13.6 mA expected"]],
                    ),
                },
            }],
        }

        learner = self.render(lesson, "learner")
        educator = self.render(lesson, "educator")

        self.assertNotIn("13.6 mA expected", learner)
        self.assertIn("&nbsp;", learner)
        self.assertIn("13.6 mA expected", educator)

    def test_malformed_table_rows_raise_a_clear_error(self):
        lesson = {
            "id": "worksheet_test",
            "steps": [{
                "stepId": "s1",
                "interactiveWidgetType": "sharedWidget",
                "interactiveConfig": {
                    "printableActivity": activity(
                        "Bad Activity", [["only one cell"]], [["also one"]]
                    ),
                },
            }],
        }

        with tempfile.TemporaryDirectory() as temp_dir:
            with self.assertRaisesRegex(ValueError, "row 1 has 1 cells; expected 2"):
                generator.render_lesson_to_html(
                    lesson, str(Path(temp_dir) / "bad.html"), mode="learner"
                )

    def test_distinct_activities_using_same_widget_both_render(self):
        lesson = {
            "id": "worksheet_test",
            "title": "Worksheet test",
            "steps": [
                {
                    "stepId": "s1",
                    "interactiveWidgetType": "sharedWidget",
                    "interactiveConfig": {
                        "printableActivity": activity(
                            "First Activity", [["A", "&nbsp;"]], [["A", "answer A"]]
                        ),
                    },
                },
                {
                    "stepId": "s2",
                    "interactiveWidgetType": "sharedWidget",
                    "interactiveConfig": {
                        "printableActivity": activity(
                            "Second Activity", [["B", "&nbsp;"]], [["B", "answer B"]]
                        ),
                    },
                },
            ],
        }

        learner = self.render(lesson, "learner")
        self.assertIn("First Activity", learner)
        self.assertIn("Second Activity", learner)


if __name__ == "__main__":
    unittest.main()
