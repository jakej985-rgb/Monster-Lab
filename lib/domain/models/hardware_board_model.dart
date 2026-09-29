class UsbIdentifier {
  final int vendorId;
  final int productId;

  const UsbIdentifier(this.vendorId, this.productId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsbIdentifier &&
          runtimeType == other.runtimeType &&
          vendorId == other.vendorId &&
          productId == other.productId;

  @override
  int get hashCode => Object.hash(vendorId, productId);

  @override
  String toString() =>
      'VID: 0x${vendorId.toRadixString(16).padLeft(4, "0").toUpperCase()}, PID: 0x${productId.toRadixString(16).padLeft(4, "0").toUpperCase()}';
}

class HardwareBoardModel {
  final String id;
  final String name;
  final String microcontroller;
  final String operatingVoltage;
  final int digitalPins;
  final int analogPins;
  final int pwmPins;
  final int defaultBaudRate;
  final List<UsbIdentifier> supportedVidsPids;
  final String description;
  final bool isVirtual;

  const HardwareBoardModel({
    required this.id,
    required this.name,
    required this.microcontroller,
    required this.operatingVoltage,
    required this.digitalPins,
    required this.analogPins,
    required this.pwmPins,
    required this.defaultBaudRate,
    this.supportedVidsPids = const [],
    required this.description,
    this.isVirtual = false,
  });
}

abstract class SupportedBoards {
  static const HardwareBoardModel virtualUno = HardwareBoardModel(
    id: 'virtual_uno',
    name: 'Monster Lab Virtual Simulator',
    microcontroller: 'Simulated ATmega328P (Uno R3)',
    operatingVoltage: '5.0V',
    digitalPins: 14,
    analogPins: 6,
    pwmPins: 6,
    defaultBaudRate: 9600,
    description:
        'Zero-hardware virtual emulator running Monster Lab companion firmware. Responds to test protocol commands and generates real-time telemetry.',
    isVirtual: true,
  );

  static const HardwareBoardModel unoR3 = HardwareBoardModel(
    id: 'uno_r3',
    name: 'Arduino Uno R3',
    microcontroller: 'ATmega328P (16MHz)',
    operatingVoltage: '5.0V',
    digitalPins: 14,
    analogPins: 6,
    pwmPins: 6,
    defaultBaudRate: 9600,
    supportedVidsPids: [
      UsbIdentifier(0x2341, 0x0043), // Official Arduino Uno 16U2
      UsbIdentifier(0x2341, 0x0001), // Uno Rev 1
      UsbIdentifier(0x1A86, 0x7523), // WCH CH340G Clone
      UsbIdentifier(0x0403, 0x6001), // FTDI FT232R Clone
    ],
    description:
        'The primary educational board in the Monster Arduino Kit. Ideal for beginner to intermediate robotics.',
  );

  static const HardwareBoardModel unoR4Minima = HardwareBoardModel(
    id: 'uno_r4_minima',
    name: 'Arduino Uno R4 Minima',
    microcontroller: 'Renesas RA4M1 (48MHz ARM Cortex-M4)',
    operatingVoltage: '5.0V',
    digitalPins: 14,
    analogPins: 6,
    pwmPins: 6,
    defaultBaudRate: 115200,
    supportedVidsPids: [
      UsbIdentifier(0x2341, 0x0069), // Official Uno R4 Minima
      UsbIdentifier(0x2341, 0x1002), // Uno R4 WiFi
    ],
    description:
        'Modern 32-bit ARM-powered Uno with built-in DAC, CAN bus, and high-speed USB-C.',
  );

  static const HardwareBoardModel nano = HardwareBoardModel(
    id: 'nano',
    name: 'Arduino Nano',
    microcontroller: 'ATmega328P (16MHz)',
    operatingVoltage: '5.0V',
    digitalPins: 14,
    analogPins: 8,
    pwmPins: 6,
    defaultBaudRate: 9600,
    supportedVidsPids: [
      UsbIdentifier(0x1A86, 0x7523), // Nano CH340 clone
      UsbIdentifier(0x0403, 0x6001), // Nano FT232R
      UsbIdentifier(0x2341, 0x0010), // Arduino Nano original
    ],
    description:
        'Compact breadboard-friendly microcontroller with 2 additional analog input channels (A6 & A7).',
  );

  static const HardwareBoardModel mega2560 = HardwareBoardModel(
    id: 'mega_2560',
    name: 'Arduino Mega 2560',
    microcontroller: 'ATmega2560 (16MHz)',
    operatingVoltage: '5.0V',
    digitalPins: 54,
    analogPins: 16,
    pwmPins: 15,
    defaultBaudRate: 9600,
    supportedVidsPids: [
      UsbIdentifier(0x2341, 0x0042), // Mega 2560 Rev 3
      UsbIdentifier(0x2341, 0x0010), // Mega 2560 Rev 1/2
      UsbIdentifier(0x1A86, 0x7523), // Mega CH340 clone
    ],
    description:
        'Heavy-duty microcontroller with 4 hardware serial UARTs, 54 digital I/O lines, and 256KB flash for complex robotics.',
  );

  static const HardwareBoardModel esp32 = HardwareBoardModel(
    id: 'esp32',
    name: 'ESP32 DevKit v1',
    microcontroller: 'Xtensa Dual-Core 32-bit LX6 (240MHz)',
    operatingVoltage: '3.3V',
    digitalPins: 30,
    analogPins: 15,
    pwmPins: 16,
    defaultBaudRate: 115200,
    supportedVidsPids: [
      UsbIdentifier(0x10C4, 0xEA60), // Silicon Labs CP2102
      UsbIdentifier(0x1A86, 0x7523), // CH340
    ],
    description:
        'High-performance IoT powerhouse with integrated 2.4GHz Wi-Fi and Bluetooth Low Energy (BLE).',
  );

  static const List<HardwareBoardModel> all = [
    virtualUno,
    unoR3,
    unoR4Minima,
    nano,
    mega2560,
    esp32,
  ];

  static HardwareBoardModel findById(String id) {
    return all.firstWhere(
      (b) => b.id == id,
      orElse: () => unoR3,
    );
  }

  static HardwareBoardModel? matchUsb(int vid, int pid) {
    for (final board in all) {
      if (board.supportedVidsPids
          .any((u) => u.vendorId == vid && u.productId == pid)) {
        return board;
      }
    }
    return null;
  }
}
