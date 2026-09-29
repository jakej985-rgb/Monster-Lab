# 04 - Hardware Integration Boundaries

## 1. Overview

While Monster Lab is built around physical Arduino kits, **the app must never require a connected physical board to function**. Many learners use mobile tablets, Chromebooks without USB access, or study while away from their workbench.

This document establishes the **Hardware Abstraction Layer (HAL)** boundaries, isolating USB serial communications, board auto-discovery, and telemetry streaming behind an event-driven contract.

---

## 2. Hardware Abstraction Layer (HAL) Architecture

```mermaid
flowchart TD
    subgraph UI_Layer ["Monster Lab UI / Labs"]
        BuildLab["Build Lab (Upload & Test Phase)"]
        PartsLab["Parts Lab (Live Sensor Scope)"]
        CodeLab["Interactive Code Lab (Serial Monitor)"]
    end

    subgraph ServiceBoundary ["Hardware Abstraction Boundary"]
        IHardwareBridge["<<Interface>> IHardwareBridge"]
    end

    subgraph Implementations ["HAL Concrete Providers"]
        PhysicalBridge["PhysicalSerialBridge (USB-UART / CH340 Driver)"]
        VirtualBridge["VirtualSimulationBridge (Synthetic Telemetry & Mock Arduino)"]
    end

    BuildLab --> IHardwareBridge
    PartsLab --> IHardwareBridge
    CodeLab --> IHardwareBridge

    IHardwareBridge <|.. PhysicalBridge
    IHardwareBridge <|.. VirtualBridge
```

---

## 3. Hardware Bridge Contract

```dart
enum HardwareConnectionState {
  disconnected,
  scanning,
  connectedPhysical,
  connectedVirtual,
  error
}

class DiscoveredBoard {
  final String portName;           // e.g. "/dev/ttyUSB0" or "COM3"
  final String boardModel;          // e.g. "Arduino Uno (CH340G)"
  final int vendorId;               // e.g. 0x1A86 (WCH CH340)
  final int productId;              // e.g. 0x7523
}

abstract class IHardwareBridge {
  /// Reactive stream of connection state updates
  Stream<HardwareConnectionState> get stateStream;

  /// Raw ASCII serial monitor output stream (e.g. Serial.println output)
  Stream<String> get rawSerialStream;

  /// Structured sensor telemetry (e.g. Ultrasonic distance, Potentiometer ADC)
  Stream<Map<String, dynamic>> get telemetryStream;

  /// Scan for connected USB devices matching Arduino VID/PIDs
  Future<List<DiscoveredBoard>> scanDevices();

  /// Connect to physical port or initialize virtual simulator
  Future<bool> connect({String? portName, int baudRate = 9600});

  /// Send test command or serial data down to the board
  Future<void> sendData(String payload);

  /// Close connection
  Future<void> disconnect();
}
```

---

## 4. Virtual Simulation Mode (Zero-Hardware Fallback)

When no physical Arduino is detected:
1. The app automatically enters **Virtual Simulation Mode**.
2. **Interactive Controls**: When testing Project 01 (*Intruder Alarm*), the app provides a visual slider to simulate moving an object closer or farther from the virtual HC-SR04 sensor.
3. **Synthetic Serial Stream**: The virtual bridge emits formatted strings (e.g. `Distance: 24 cm`) at 10Hz into `rawSerialStream`, allowing the in-app Serial Monitor to behave exactly as if a real Arduino were transmitting data.
4. **Educational Parity**: Learners complete 100% of the wiring checks, code reviews, and challenge evaluations using the virtual simulator without being penalized.
