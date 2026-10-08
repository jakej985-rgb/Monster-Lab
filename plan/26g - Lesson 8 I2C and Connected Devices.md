# Phase 26g - Lesson 8 I2C & Connected Devices

## Goal
Rebuild the old I2C lesson so it follows the new hardware, input, sensor, and library foundation.

## Required Readiness
Arduino pins, power/GND, circuits, breadboards, inputs, sensors, libraries, and basic code concepts.

## Progression
Why devices communicate → two wires → addresses → library → first device → multiple devices → troubleshooting.

## Target Submodules
8.1 Why Do Devices Need to Talk?
8.2 Meet I2C
8.3 SDA and SCL
8.4 I2C Addresses
8.5 Your First I2C Device
8.6 I2C LCD
8.7 I2C Sensor
8.8 Multiple I2C Devices
8.9 I2C Troubleshooting
8.10 I2C Challenge

## Beginner Explanation
Start with the problem: how can another device send information to Arduino? Then introduce I2C as a shared communication path using a simple analogy.

## Technical Progression
Introduce SDA, SCL, addresses, controller/device roles, pull-ups, and shared-bus behavior only after the basic concept is understood.

## Library Connection
Explicitly connect to Lesson 3: install a device library, run its example, modify it, and understand which library functions communicate with the device.

## Hands-On
Wire one device, run an example, observe output, modify it, add a second device, then diagnose a communication problem.

## Troubleshooting
Swapped SDA/SCL, missing GND, wrong address, wrong library, loose wiring, incompatible device, and address conflicts.

## Challenge
Build a small information station using a sensor and I2C display. Advanced version adds a second I2C device.

## Boundary
Lesson 3 = libraries. Lesson 8 = communication using a library and physical devices.

## Validation
I2C must appear only after the learner has enough hardware, sensor, and library experience.


## Pre-Test / Readiness Check

Every Lesson 8 submodule gets **2 prerequisite questions**.

Questions should diagnose:
- pins and wiring
- power/GND
- sensors
- libraries
- basic input/output concepts
- Serial Monitor
- the idea that devices can exchange information

Later I2C submodules may test readiness for SDA/SCL, addresses, and device roles only after those ideas have been introduced.

### Readiness
- 2/2 = 🟢 Green — Ready
- 0–1/2 = 🟡 Yellow — Warm Up

Yellow learners receive a short targeted review. No red state and no blocking.
