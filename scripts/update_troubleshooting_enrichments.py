import re
from pathlib import Path

ENRICH_PATH = Path("/home/m3tal/apps/Monster-Lab/scripts/project_enrichments.py")

with open(ENRICH_PATH, "r", encoding="utf-8") as f:
    content = f.read()

# Let's inspect project_enrichments.py structure
# We can load the PROJECT_ENRICHMENTS dictionary, enrich every troubleshooting item, and re-serialize or format it cleanly.
import importlib.util

spec = importlib.util.spec_from_file_location("project_enrichments", str(ENRICH_PATH))
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)
enrichments = mod.PROJECT_ENRICHMENTS

CATEGORIES_MAP = {
    "Distance always reads 0 or 3000 cm": ("logic", ["Check TRIG on Pin 9 and ECHO on Pin 10.", "Ensure VCC is connected to 5V (not 3.3V).", "Verify acoustic line of sight is clear."]),
    "Buzzer clicks faintly but makes no siren": ("wiring", ["Peel off the yellow protective sticker on top.", "Ensure longer (+) pin is connected to Pin 8 and (-) to GND."]),
    "LED does not illuminate": ("wiring", ["Rotate LED 180 degrees to verify polarity.", "Check that 220Ω resistor connects cathode to GND."]),
    "LEDs are permanently ON even when quiet": ("logic", ["Use a small screwdriver to turn the blue potentiometer on the microphone module.", "Open Serial Monitor to observe live acoustic baseline numbers."]),
    "Remote button presses do nothing": ("wiring", ["Check if the transparent plastic battery tab is pulled from the IR remote.", "Verify IR receiver signal wire is in digital pin 11."]),
    "Keypad presses do not register": ("wiring", ["Verify ribbon cable row/column order against pin table.", "Ensure keypad library #include <Keypad.h> is installed in Arduino IDE."]),
    "LCD shows 16 solid white boxes and no text": ("logic", ["Turn the brass contrast trimmer screw on the back of the I2C backpack.", "Run an I2C scanner sketch to verify if address is 0x27 or 0x3F."]),
    "Time resets to 2000/01/01 every time USB is unplugged": ("power", ["Check CR2032 coin battery orientation (+ side facing up).", "Verify battery contacts are clean and tight."]),
    "Sensor metal cap feels warm": ("power", ["This is normal: MQ gas sensors have internal 5V heaters.", "Wait 3 minutes for heater stabilization before testing gas."]),
    "Alarm triggers immediately on power up": ("logic", ["Allow 2-3 minutes preheat burn-in cycle in clean air.", "Tune threshold potentiometer until alarm SILENCES in fresh air."]),
    "Servo twitches and resets Arduino when activating": ("power", ["Servo draws high inrush current causing brownout reset.", "Add external 4xAA battery pack with shared ground to Arduino GND."]),
    "Stepper motor vibrates and buzzes but does not rotate": ("wiring", ["Check 4-phase sequence wires (IN1 to IN4) on driver board.", "Ensure 5V power supply has enough current (>500mA)."]),
    "RFID reader does not detect cards at all": ("wiring", ["Check RC522 VCC wire: strictly 3.3V (5V will damage it).", "Inspect SPI jumper connections: MOSI 11, MISO 12, SCK 13."]),
    "Encoder skips numbers or increments randomly": ("logic", ["Check CLK and DT pull-up resistors or software debouncing.", "Verify interrupt service routine has no delay() calls."]),
    "Servos violently jitter during radar sweep": ("power", ["Two servos exceed 500mA USB limit simultaneously.", "Power servo rail with external 5V/6V supply and bridge GNDs."]),
    "Water level reading is erratic or fluctuating wildly": ("wiring", ["Wipe trace electrodes dry with paper towel.", "Verify analog pin A0 wire has good breadboard grip."]),
    "MPU-6050 readings always return -1 or 0": ("logic", ["Write 0x00 to power management register 0x6B to wake from sleep.", "Verify SDA on A4 and SCL on A5."]),
    "radio.begin() fails or packets drop frequently": ("power", ["Add a 10uF capacitor across NRF24L01 VCC and GND pins.", "Ensure VCC is connected to 3.3V only (not 5V)."]),
}

for pid, pdata in enrichments.items():
    if "troubleshooting" in pdata:
        for item in pdata["troubleshooting"]:
            sym = item["symptom"]
            if sym in CATEGORIES_MAP:
                cat, steps = CATEGORIES_MAP[sym]
                item["category"] = cat
                item["diagnosticSteps"] = steps
            else:
                # Default inference
                if "power" in sym.lower() or "reset" in sym.lower() or "warm" in sym.lower():
                    item["category"] = "power"
                    item["diagnosticSteps"] = ["Inspect 5V and GND rail connections.", "Verify current draw stays within safe limits."]
                elif "pin" in sym.lower() or "wire" in sym.lower() or "connect" in sym.lower():
                    item["category"] = "wiring"
                    item["diagnosticSteps"] = ["Check breadboard row alignment.", "Trace wire back to Arduino header."]
                elif "read" in sym.lower() or "erratic" in sym.lower() or "sensor" in sym.lower():
                    item["category"] = "logic"
                    item["diagnosticSteps"] = ["Inspect sensor calibration values in Serial Monitor.", "Check pull-up/pull-down resistor stability."]
                else:
                    item["category"] = "wiring"
                    item["diagnosticSteps"] = ["Double check circuit schematic.", "Verify component leg orientation."]

import json
print("Updated enrichments successfully.")

# Re-write project_enrichments.py
output_code = "PROJECT_ENRICHMENTS = " + json.dumps(enrichments, indent=4) + "\n"
with open(ENRICH_PATH, "w", encoding="utf-8") as f:
    f.write(output_code)
print("Saved PROJECT_ENRICHMENTS to project_enrichments.py")
