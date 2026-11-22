import 'hardware_board_model.dart';

enum DeviceFeature {
  digitalIo,
  analogRead,
  pwmOutput,
  i2c,
  spi,
  uart,
  wifi,
  ble,
  hardwareInterrupts,
  dac,
  canBus,
}

class DeviceCapabilities {
  final String boardId;
  final String boardName;
  final String architecture;
  final double operatingVoltage;
  final double maxInputVoltage;
  final int maxDigitalPins;
  final int maxAnalogPins;
  final int maxPwmPins;
  final List<int> supportedBaudRates;
  final Set<String> supportedCommands;
  final Set<DeviceFeature> features;

  const DeviceCapabilities({
    required this.boardId,
    required this.boardName,
    required this.architecture,
    required this.operatingVoltage,
    required this.maxInputVoltage,
    required this.maxDigitalPins,
    required this.maxAnalogPins,
    required this.maxPwmPins,
    required this.supportedBaudRates,
    required this.supportedCommands,
    required this.features,
  });

  bool supportsCommand(String command) {
    final clean = command.trim().toUpperCase();
    final verb = clean.contains(':') ? clean.split(':').first : clean;
    return supportedCommands.contains(verb) ||
        supportedCommands.contains(clean);
  }

  bool isPinValid(int pin, {bool isAnalog = false}) {
    if (pin < 0) return false;
    if (isAnalog) {
      return pin < maxAnalogPins;
    }
    return pin < maxDigitalPins;
  }

  bool isBaudRateSupported(int baudRate) {
    return supportedBaudRates.contains(baudRate);
  }

  bool isVoltageSafe(double targetVoltage) {
    return targetVoltage <= maxInputVoltage + 0.05;
  }
}

class HardwareDeviceCapabilityRegistry {
  static const Set<String> _universalCommands = {
    'PING',
    'STATUS',
    'HELP',
    'RESET',
    'HANDSHAKE',
    'HELLO',
    'SAFE_STATE',
    'EMERGENCY_STOP',
    'LED',
    'ANALOG',
    'SONAR',
    'PWM',
    'DIGITAL',
  };

  static final Map<String, DeviceCapabilities> _registry = {
    'virtual_uno': const DeviceCapabilities(
      boardId: 'virtual_uno',
      boardName: 'Monster Lab Virtual Simulator',
      architecture: 'Simulated ATmega328P (Uno R3)',
      operatingVoltage: 5.0,
      maxInputVoltage: 5.5,
      maxDigitalPins: 14,
      maxAnalogPins: 6,
      maxPwmPins: 6,
      supportedBaudRates: [9600, 19200, 38400, 57600, 115200],
      supportedCommands: _universalCommands,
      features: {
        DeviceFeature.digitalIo,
        DeviceFeature.analogRead,
        DeviceFeature.pwmOutput,
        DeviceFeature.i2c,
        DeviceFeature.spi,
        DeviceFeature.uart,
        DeviceFeature.hardwareInterrupts,
      },
    ),
    'uno_r3': const DeviceCapabilities(
      boardId: 'uno_r3',
      boardName: 'Arduino Uno R3',
      architecture: 'AVR 8-bit (ATmega328P)',
      operatingVoltage: 5.0,
      maxInputVoltage: 5.5,
      maxDigitalPins: 14,
      maxAnalogPins: 6,
      maxPwmPins: 6,
      supportedBaudRates: [9600, 19200, 38400, 57600, 115200],
      supportedCommands: _universalCommands,
      features: {
        DeviceFeature.digitalIo,
        DeviceFeature.analogRead,
        DeviceFeature.pwmOutput,
        DeviceFeature.i2c,
        DeviceFeature.spi,
        DeviceFeature.uart,
        DeviceFeature.hardwareInterrupts,
      },
    ),
    'uno_r4_minima': const DeviceCapabilities(
      boardId: 'uno_r4_minima',
      boardName: 'Arduino Uno R4 Minima',
      architecture: 'ARM Cortex-M4 32-bit (RA4M1)',
      operatingVoltage: 5.0,
      maxInputVoltage: 5.5,
      maxDigitalPins: 14,
      maxAnalogPins: 6,
      maxPwmPins: 6,
      supportedBaudRates: [9600, 19200, 38400, 57600, 115200, 230400],
      supportedCommands: _universalCommands,
      features: {
        DeviceFeature.digitalIo,
        DeviceFeature.analogRead,
        DeviceFeature.pwmOutput,
        DeviceFeature.i2c,
        DeviceFeature.spi,
        DeviceFeature.uart,
        DeviceFeature.hardwareInterrupts,
        DeviceFeature.dac,
        DeviceFeature.canBus,
      },
    ),
    'nano': const DeviceCapabilities(
      boardId: 'nano',
      boardName: 'Arduino Nano',
      architecture: 'AVR 8-bit (ATmega328P)',
      operatingVoltage: 5.0,
      maxInputVoltage: 5.5,
      maxDigitalPins: 14,
      maxAnalogPins: 8,
      maxPwmPins: 6,
      supportedBaudRates: [9600, 19200, 38400, 57600, 115200],
      supportedCommands: _universalCommands,
      features: {
        DeviceFeature.digitalIo,
        DeviceFeature.analogRead,
        DeviceFeature.pwmOutput,
        DeviceFeature.i2c,
        DeviceFeature.spi,
        DeviceFeature.uart,
        DeviceFeature.hardwareInterrupts,
      },
    ),
    'mega_2560': const DeviceCapabilities(
      boardId: 'mega_2560',
      boardName: 'Arduino Mega 2560',
      architecture: 'AVR 8-bit (ATmega2560)',
      operatingVoltage: 5.0,
      maxInputVoltage: 5.5,
      maxDigitalPins: 54,
      maxAnalogPins: 16,
      maxPwmPins: 15,
      supportedBaudRates: [9600, 19200, 38400, 57600, 115200],
      supportedCommands: _universalCommands,
      features: {
        DeviceFeature.digitalIo,
        DeviceFeature.analogRead,
        DeviceFeature.pwmOutput,
        DeviceFeature.i2c,
        DeviceFeature.spi,
        DeviceFeature.uart,
        DeviceFeature.hardwareInterrupts,
      },
    ),
    // Unknown Web Serial devices get a conservative 3.3V profile so the
    // interlock never assumes 5V tolerance without a known board ID.
    'usb_serial': const DeviceCapabilities(
      boardId: 'usb_serial',
      boardName: 'USB Serial Device',
      architecture: 'Unknown USB-UART bridge',
      operatingVoltage: 3.3,
      maxInputVoltage: 3.6,
      maxDigitalPins: 14,
      maxAnalogPins: 6,
      maxPwmPins: 6,
      supportedBaudRates: [9600, 19200, 38400, 57600, 115200],
      supportedCommands: _universalCommands,
      features: {
        DeviceFeature.digitalIo,
        DeviceFeature.analogRead,
        DeviceFeature.uart,
      },
    ),
    'esp32': const DeviceCapabilities(
      boardId: 'esp32',
      boardName: 'ESP32 DevKit v1',
      architecture: 'Xtensa Dual-Core 32-bit (LX6)',
      operatingVoltage: 3.3,
      maxInputVoltage: 3.6,
      maxDigitalPins: 30,
      maxAnalogPins: 15,
      maxPwmPins: 16,
      supportedBaudRates: [9600, 115200, 230400, 921600],
      supportedCommands: _universalCommands,
      features: {
        DeviceFeature.digitalIo,
        DeviceFeature.analogRead,
        DeviceFeature.pwmOutput,
        DeviceFeature.i2c,
        DeviceFeature.spi,
        DeviceFeature.uart,
        DeviceFeature.wifi,
        DeviceFeature.ble,
        DeviceFeature.hardwareInterrupts,
        DeviceFeature.dac,
      },
    ),
  };

  static DeviceCapabilities? getCapabilities(String boardId) {
    return _registry[boardId];
  }

  static DeviceCapabilities findForBoard(HardwareBoardModel board) {
    return _registry[board.id] ?? _registry['uno_r3']!;
  }

  static List<DeviceCapabilities> getAll() {
    return _registry.values.toList();
  }

  static List<String> validateRegistry() {
    final issues = <String>[];
    for (final board in SupportedBoards.all) {
      final cap = _registry[board.id];
      if (cap == null) {
        issues.add(
            "Missing capability entry for registered board: '${board.id}'");
        continue;
      }
      if (cap.supportedBaudRates.isEmpty) {
        issues.add("Board '${board.id}' has empty supported baud rates list");
      }
      if (cap.supportedCommands.isEmpty) {
        issues.add("Board '${board.id}' has empty supported commands set");
      }
      if (cap.operatingVoltage <= 0.0) {
        issues.add(
            "Board '${board.id}' has invalid operating voltage: ${cap.operatingVoltage}");
      }
    }
    return issues;
  }
}
