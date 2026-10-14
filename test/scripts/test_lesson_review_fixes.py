import json
import importlib.util
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
IN_APP_SCRIPT_PATH = ROOT / "scripts" / "render_in_app_lesson.py"
SPEC = importlib.util.spec_from_file_location("render_in_app_lesson", IN_APP_SCRIPT_PATH)
in_app_renderer = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(in_app_renderer)


class LessonReviewContentTests(unittest.TestCase):
    def test_l10_06_rfid_rectifier_wording_and_range_qualification(self):
        lesson_file = ROOT / "assets" / "curriculum" / "lessons" / "l10_06.json"
        data = json.loads(lesson_file.read_text(encoding="utf-8"))

        s1_md = data["steps"][0]["markdownContent"]
        # Must not contain inaccurate capacitor rectifier claim
        self.assertNotIn("A tiny internal capacitor rectifies", s1_md)
        self.assertNotIn("a tiny internal capacitor rectifies", s1_md)

        # Must accurately explain rectifier converts AC to DC and capacitors smooth/store
        self.assertIn("rectifier converts this induced alternating voltage into direct current (DC)", s1_md)
        self.assertIn("capacitors smooth or store energy", s1_md)

        # 3 cm range must be qualified as simulated threshold, not universal physical claim
        self.assertIn("the simulator models a threshold of 3 cm", s1_md)
        self.assertIn("physical range varies with reader/tag antennas", s1_md)

        # Step 2 simulation explanation qualification
        s2_md = data["steps"][1]["markdownContent"]
        self.assertIn("simulated 3 cm read threshold", s2_md)
        self.assertIn("physical read range varies", s2_md)

        # Config integrity
        cfg = data["steps"][1]["interactiveConfig"]
        self.assertEqual(cfg.get("readRangeCm"), 3.0)
        self.assertEqual(cfg.get("frequencyMHz"), 13.56)
        self.assertEqual(cfg.get("demoUid"), "DE AD BE EF")

    def test_l12_02_flyback_educator_key_caveat_and_config(self):
        lesson_file = ROOT / "assets" / "curriculum" / "lessons" / "l12_02.json"
        data = json.loads(lesson_file.read_text(encoding="utf-8"))

        cfg = data["steps"][2]["interactiveConfig"]
        self.assertEqual(cfg.get("supplyVoltageV"), 5.0)
        self.assertEqual(cfg.get("diodeForwardVoltageV"), 0.7)

        table = cfg["printableActivity"]["table"]
        educator_rows = table["educatorRows"]

        # Step 3 educator row must contain illustrative 85 V spike caveat
        step3_row = next(r for r in educator_rows if "Step 3" in r[0])
        self.assertTrue(
            any("85 V illustrative model spike" in cell or "illustrative" in cell for cell in step3_row)
        )
        self.assertTrue(
            any("real transient voltage depends on motor, driver, and circuit" in cell for cell in step3_row)
        )

        # Step 4 row verifies ~5.7 V clamped calculation (5.0 V + 0.7 V)
        step4_row = next(r for r in educator_rows if "Step 4" in r[0])
        self.assertTrue(any("~5.7V" in cell for cell in step4_row))

    def test_l06_04_resistor_consistency_and_worksheet(self):
        lesson_file = ROOT / "assets" / "curriculum" / "lessons" / "l06_04.json"
        data = json.loads(lesson_file.read_text(encoding="utf-8"))

        s3 = data["steps"][2]
        table = s3["interactiveConfig"]["printableActivity"]["table"]
        learner_rows = table["learnerRows"]
        educator_rows = table["educatorRows"]

        # Blank learner worksheet cells preserved
        for row in learner_rows:
            self.assertEqual(row[1], "&nbsp;")
            self.assertEqual(row[2], "&nbsp;")
            self.assertEqual(row[3], "&nbsp;")

        # Filled educator rows with expected values
        row_220 = next(r for r in educator_rows if "220 Ω" in r[0])
        self.assertIn("13.6 mA", row_220[1])

        row_10k = next(r for r in educator_rows if "10k Ω" in r[0])
        self.assertIn("0.3 mA", row_10k[1])

        # Mathematical verification: (5.0V - 2.0V) / 220 = 13.6 mA, (5.0V - 2.0V) / 10000 = 0.3 mA
        v_s = 5.0
        v_f = 2.0
        v_r = v_s - v_f
        i_220 = (v_r / 220.0) * 1000
        i_10k = (v_r / 10000.0) * 1000
        self.assertAlmostEqual(i_220, 13.636, places=1)
        self.assertAlmostEqual(i_10k, 0.3, places=1)

    def test_manifest_contains_target_lessons(self):
        manifest_file = ROOT / "assets" / "curriculum" / "manifest.json"
        manifest = json.loads(manifest_file.read_text(encoding="utf-8"))
        lessons = manifest.get("lessons", [])
        self.assertIn("l06_04", lessons)
        self.assertIn("l10_06", lessons)
        self.assertIn("l12_02", lessons)


class InAppPreviewRendererTests(unittest.TestCase):
    def test_rfid_static_review_mockup_generation(self):
        lesson_file = ROOT / "assets" / "curriculum" / "lessons" / "l10_06.json"
        lesson_data = json.loads(lesson_file.read_text(encoding="utf-8"))
        step2 = lesson_data["steps"][1]

        rendered_step = in_app_renderer.render_step_card(
            step=step2,
            step_idx=2,
            total_steps=len(lesson_data["steps"]),
            lesson_id="l10_06",
            lesson_data=lesson_data,
        )

        # 1. Must be clearly labeled as static review mockup
        self.assertIn("STATIC REVIEW MOCKUP", rendered_step)
        self.assertIn("RFID Coupling &amp; UID Read Simulator", rendered_step)

        # 2. 13.56 MHz field and 0-6 cm scale with 3.0 cm threshold and 5.0 cm default
        self.assertIn("13.56 MHz", rendered_step)
        self.assertIn("Distance Scale (0 to 6 cm)", rendered_step)
        self.assertIn("3.0 cm threshold", rendered_step)
        self.assertIn("Tag at 5.0 cm (Default)", rendered_step)

        # 3. Unavailable read action while out of range
        self.assertIn("TAG NOT POWERED — OUT OF RANGE", rendered_step)
        self.assertIn("Read UID (Unavailable out of range)", rendered_step)
        self.assertIn("disabled", rendered_step)

        # 4. In-range read sequence stages
        self.assertIn("Tag load modulation", rendered_step)
        self.assertIn("RC522 receives", rendered_step)
        self.assertIn("SPI transfer", rendered_step)
        self.assertIn("DE AD BE EF", rendered_step)

        # 5. SPI signal roles
        self.assertIn("MOSI", rendered_step)
        self.assertIn("Uno → RC522: command data", rendered_step)
        self.assertIn("SCK", rendered_step)
        self.assertIn("Uno → RC522: clock", rendered_step)
        self.assertIn("CS", rendered_step)
        self.assertIn("Uno → RC522: select reader", rendered_step)
        self.assertIn("MISO", rendered_step)
        self.assertIn("RC522 → Uno: returned UID bytes", rendered_step)

        # 6. Must NOT dump raw JSON config or render old signal-flow widget
        self.assertNotIn("visual-flow-widget", rendered_step)
        self.assertNotIn("config-dump", rendered_step)


if __name__ == "__main__":
    unittest.main()
