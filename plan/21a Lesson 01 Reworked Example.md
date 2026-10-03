# 21a Lesson 01 Reworked Example

## Purpose
Show exactly how Lesson 01 should look after applying Phase 21.

## Lesson
**Title:** What Is Arduino & How Does It Work?
**Tier:** Rookie
**Target Time:** 15–20 minutes
**Prerequisites:** None
**XP:** 50

## Learning Goals
- Explain what an Arduino is.
- Explain what a microcontroller does.
- Identify inputs and outputs.
- Identify basic Arduino Uno connections.
- Explain why a circuit needs power and ground.
- Recognize digital versus analog signals.
- Read a very small piece of Arduino code.
- Predict what a simple Arduino instruction will do.

## 1. Mission Introduction
### Meet the Monster Brain
A robot needs a brain. The Arduino Uno is a small microcontroller development board that can read information from the world and control electronic devices.

It can read a button, measure a sensor, turn an LED on or off, control a motor through a driver, and communicate with other electronics.

The Arduino does not magically know what to do. A program tells it what to look for and what actions to take.

**Sensor → Arduino → Decision → Output**

## 2. What Is a Microcontroller?
A microcontroller is a small computer designed to control electronics. Unlike a desktop computer, it is designed to interact directly with hardware.

It contains a processor that runs instructions, memory for programs and data, input/output connections, timers, and other hardware used by programs.

### Vocabulary
- **Microcontroller:** A small computer designed to control electronic hardware.
- **Program:** Instructions that tell a computer what to do.
- **Input:** Information entering the controller.
- **Output:** An action or signal produced by the controller.

## 3. Inputs and Outputs
Robots need ways to sense and act.

### Inputs
- Pushbutton
- Distance sensor
- Sound sensor
- Potentiometer
- Light sensor

### Outputs
- LED
- Buzzer
- Display
- Motor driver
- Servo

### Think Like a Robot
Ask the learner to classify an ultrasonic sensor, LED, pushbutton, and motor driver as input or output.

Example: If a robot needs to know whether someone pressed a button, is the button an input or an output?

**Answer:** Input.

## 4. Digital vs Analog
Digital information can represent distinct states. For a simple Arduino input this is often HIGH or LOW, similar to ON or OFF.

Analog information can represent changing values such as temperature, light level, knob position, or sound level.

### Quick Prediction
A potentiometer is turned slowly from one end to the other. Would its reading stay the same, change gradually, or only have two possible values?

**Answer:** Change gradually.

## 5. Meet the Arduino Uno
Have the learner physically locate:
- USB connection
- Power connection
- Digital pins
- Analog pins
- 5V
- 3.3V
- GND
- Reset button
- Built-in LED

### Physical Mission
1. Find 5V.
2. Find GND.
3. Find one digital pin.
4. Find one analog pin.
5. Find the built-in LED.
6. Identify the USB connection.

Do not connect anything yet. The goal is identification.

## 6. Why Power and Ground Matter
Electronic circuits need a complete electrical path.

For a simple circuit, electrical energy travels from the power source through the components and returns through the circuit's ground/reference path.

A common pattern is:

**Power → Component → GND**

Important: GND does not mean the electricity simply disappears. It is the circuit's reference and return path.

## 7. How the Robot Brain Makes Decisions
Suppose we want a robot to turn on an LED when a button is pressed:

1. Button provides an input.
2. Arduino reads the input.
3. Program checks the value.
4. Program decides what to do.
5. Arduino controls the LED.

This introduces an important programming idea:

**condition → decision → action**

## 8. Your First Tiny Piece of Code
Before giving the learner a complete sketch, introduce one instruction:

    digitalWrite(13, HIGH);

### Break It Apart
- **digitalWrite:** A function that sets a digital output.
- **13:** The digital pin being controlled.
- **HIGH:** The requested high/on state.
- **;:** Marks the end of the statement.

### Code Prediction
If pin 13 controls the built-in LED, what do you predict this instruction will do?

**Expected answer:** Command the LED on.

The goal is learning to read code, not simply copy it.

## 9. Trust but Verify
A programmer should not blindly trust code copied from the internet.

Before uploading code, ask:
- What pin does it use?
- Is that pin connected to the component?
- What do the important numbers mean?
- What should happen?
- What could go wrong?

Teach the habit: **Read → Predict → Upload → Observe → Verify → Change → Test.**

## 10. Real-World Robot Example
Imagine a robot that needs to avoid walls.

**Ultrasonic sensor → measures distance**

**Arduino → reads the measurement**

**Program → decides whether the robot is too close**

**Motor driver → controls the motors**

This same input/decision/output pattern appears in robot vacuums, automatic doors, factory robots, alarm systems, and smart devices.

## 11. Troubleshooting Challenge
### Scenario
A learner says: My LED code does not work.

Have the learner investigate:
1. Is the Arduino powered?
2. Is the correct board selected?
3. Is the correct pin being used?
4. Is the LED connected to that pin?
5. Is the code using HIGH or LOW?
6. Was the program successfully uploaded?

### Engineering Habit
**Observe → Form a theory → Test → Learn**

Do not randomly change everything.

## 12. Knowledge Check
Use a larger assessment than the original single question.

1. What is a microcontroller?
   - A small computer designed to control electronics.
   - A battery.
   - A mechanical switch.

2. A distance sensor sends information to Arduino. Is it an input or output?
   - Input.
   - Output.
   - Power supply.

3. An LED controlled by Arduino is an example of what?
   - Input.
   - Output.
   - Ground.

4. What is GND used for in a typical circuit?
   - Unlimited power.
   - A common reference and return path.
   - Storing the program.

5. What does HIGH represent in a simple digital output?
   - The output's high/on state.
   - A program error.
   - A sensor failure.

6. What does 13 mean in digitalWrite(13, HIGH);?
   - The pin being controlled.
   - The amount of memory.
   - The Arduino speed.

7. A potentiometer produces a changing voltage as it turns. Is this digital or analog information?
   - Analog.
   - Digital only.
   - Neither.

8. Why should you understand code before uploading it?
   - So you can predict behavior and troubleshoot problems.
   - Arduino refuses copied code.
   - Every program must be memorized.

## 13. Final Review
### You Learned
- Arduino is a development board built around a microcontroller.
- A microcontroller runs programs that control electronics.
- Inputs provide information.
- Outputs perform actions.
- Digital signals can represent distinct states.
- Analog signals can represent changing values.
- Power and GND are fundamental to circuits.
- Code contains instructions that control hardware.
- Pin numbers matter.
- Good engineers predict, test, and troubleshoot.

### Before You Continue
Ask the learner:
- What is the input?
- What is the output?
- What pin is being used?
- What is the code telling the hardware to do?

## Estimated Time Breakdown
| Activity | Target |
|---|---:|
| Mission introduction | 1 min |
| Microcontroller explanation | 2 min |
| Inputs/outputs | 2 min |
| Digital vs analog | 2 min |
| Physical Arduino identification | 3–4 min |
| Power/GND explanation | 1–2 min |
| Code walkthrough | 2 min |
| Real-world example | 1 min |
| Troubleshooting | 1–2 min |
| Knowledge check | 2–3 min |
| Final review | 1 min |
| **Total** | **18–20 min** |

## Implementation Notes
- Break these sections into lesson step objects.
- Support reading/content steps.
- Support vocabulary.
- Support prior-knowledge questions.
- Support code explanation.
- Support code prediction.
- Support physical tasks.
- Support troubleshooting.
- Support multiple quiz questions.
- Track progress through the expanded lesson.
- Preserve the existing completion system.

## Done When
- Lesson 01 provides a real 15–20 minute learning experience.
- A complete beginner can understand the lesson.
- A learner with coding experience can move quickly through familiar material.
- The learner understands the purpose of the code before using it.
- The learner performs a physical identification task.
- The learner practices prediction and troubleshooting.
- The final assessment checks multiple concepts.