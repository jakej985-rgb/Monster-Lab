# 05 - Safety Notes & Age-Appropriate Handling Guidelines

## 1. Overview

Robotics and electronics education involves physical components that carry genuine risks if misused: thermal heating, electrical shorts, mechanical pinch points, coherent optical radiation, and chemical/combustion hazards.

This document establishes the safety policy for Monster Lab. It flags high-risk components in the Monster kit archive, eliminates unsafe testing practices suggested in older manuals, and provides child-safe alternative experiments.

---

## 2. High-Risk Component Assessment & Protocols

### 2.1 Peripheral 37: Laser Diode Module (KY-008)
- **Used In**: Project 11 (*Sentry Guard MONSTER*)
- **Hazard Analysis**: Emits a 650nm coherent red laser beam (Class 2 / 3R rating, <5mW). Direct ocular exposure or specular reflection off mirrors, glass, or polished metals can cause permanent retinal burn injury. In Project 11, the laser is mounted to an automated motorized pan servo, increasing sweep unpredictability.
- **Strict Guidelines**:
  - **Mandatory Parent Toggle**: The laser module is locked behind Parent Mode by default.
  - **Child-Safe Alternative**: Monster Lab provides a drop-in replacement activity using a 5mm high-brightness red LED instead of the laser module. The code and circuit function identically.
  - **Handling Rules**: Never look directly into the beam aperture. Never point the beam toward people, pets, windows, or shiny surfaces. Keep stationary when powered.

### 2.2 Peripheral 36: 5V Single-Channel Relay Module
- **Used In**: General automation and switching
- **Hazard Analysis**: The relay module features screw terminal blocks rated for up to 250V AC / 10A. Many third-party Arduino tutorials demonstrate using relays to control 120V/240V AC household appliances (lamps, wall sockets, blenders). Contact with AC mains is lethal.
- **Strict Guidelines**:
  - **ABSOLUTE PROHIBITION of AC Mains Voltage**: Monster Lab curriculum and interactive guides strictly prohibit connecting AC household electricity to the relay.
  - **Child-Safe Limitation**: Relay experiments are strictly limited to low-voltage DC circuits only (≤ 12V DC, such as battery-powered buzzers, small toy motors, or 9V battery LEDs).
  - Explicit warning badges appear on any lesson discussing relay coils.

### 2.3 Peripherals 16 & 17: MQ-3 Alcohol & MQ-9 Combustible Gas Sensors
- **Used In**: Project 06 (*Gas Leak Detection and Warning*)
- **Hazard Analysis**:
  - Both sensors utilize an internal tin-dioxide ($SnO_2$) heating element operating at high temperatures (~50°C to 60°C). Touching the metal mesh after power-up can cause minor contact burns.
  - Traditional hobbyist tutorials advise testing MQ-9 by clicking a butane cigarette lighter without striking a spark, spraying raw flammable gas into the room.
  - Testing MQ-3 with beverage alcohol is inappropriate for kids.
- **Strict Guidelines**:
  - **No Open Gas or Flame**: Never use butane lighters, propane, or fuel canisters.
  - **Child-Safe Alternative for MQ-3**: Use a standard sealed medical isopropyl alcohol wipe, held 2-3 inches away from the sensor under adult supervision.
  - **Child-Safe Alternative for MQ-9**: Demonstrate the sensor using human exhaled breath (detects moisture/CO changes) or utilize the software simulation mode in the app.
  - Allow the sensor to cool for 2 minutes after disconnecting power before touching.

### 2.4 Peripheral 11: Infrared Flame Sensor
- **Used In**: Fire detection circuits
- **Hazard Analysis**: The phototransistor detects infrared radiation in the 760nm–1100nm spectrum. Kit manuals suggest lighting matches or candles near the breadboard to trigger detection.
- **Strict Guidelines**:
  - **Zero Open Flame Policy**: Children must never strike matches, lighters, or light candles.
  - **Child-Safe Alternative**: The sensor phototransistor responds strongly to the infrared LED on the TV / IR Remote Control (Peripheral 13) or an incandescent flashlight. The lesson specifically instructs testing with the IR remote.

### 2.5 Peripherals 25, 27, 33: Motors & Mechanical Kinematics
- **Used In**: Projects 04, 07, 08, 10, 11, 13 (Servos, DC Toy Motors, Stepper Motors)
- **Hazard Analysis**:
  - 130 DC motors spin at up to 9,000 RPM. Loose long hair, necklaces, or hoodie drawstrings can rapidly wrap around rotating shafts.
  - Servos and stepper gear trains generate high torque capable of pinching fingers.
  - Inductive flyback: Shutting off a motor induces high-voltage reverse voltage spikes that can destroy the microcontroller.
- **Strict Guidelines**:
  - Always tie back long hair and remove dangling jewelry before testing spinning motors.
  - Flyback diodes (1N4007) and separate external power rails are mandatory in motor wiring diagrams.
  - Keep fingers clear of servo horns when initializing positions.

### 2.6 Power Supply, Lithium & Short Circuit Protection
- **Hazard Analysis**: Accidentally connecting `5V` or `VIN` directly to `GND` on a breadboard causes a low-resistance dead short. This can rapidly overheat breadboard wire insulation, rupture 9V alkaline batteries, or trigger protective thermal shutoff on host computer USB ports.
- **Strict Guidelines**:
  - **Pre-Flight Wiring Checklist**: Kids must complete an interactive in-app visual checklist before connecting USB or battery power.
  - **Battery Snap Precaution**: Disconnect 9V battery snaps whenever modifying breadboard wires. Never leave connected circuits unattended.

---

## 3. Age-Appropriateness Matrix

| Age Bracket | Recommended Tiers & Activities | Restricted / Supervised Items |
|---|---|---|
| **Ages 7 – 9** | **Rookie Tier**: LEDs, pushbuttons, passive buzzer melodies, light-dependent resistors, basic breadboarding. | Motors require supervision; laser and gas sensors locked out. |
| **Ages 10 – 12** | **Builder Tier**: I2C LCD screens, ultrasonic obstacle detection, servo robotic doors, keypad locks, alarm clocks. | Adult assistance recommended for first motor driver setup and external power rails. |
| **Ages 13+** | **Engineer & Master Tiers**: Multi-node wireless communication, MPU-6050 flight balancing, rotary menus, RFID authentication. | Full access with established safety checklist habits. |
