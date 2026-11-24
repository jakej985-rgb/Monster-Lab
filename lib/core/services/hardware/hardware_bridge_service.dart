import 'composite_hardware_bridge.dart';
import 'hardware_bridge.dart';
import 'virtual_simulation_bridge.dart';

class HardwareBridgeService {
  /// Toggle physical hardware support.
  static bool enablePhysicalHardware = true;

  static IHardwareBridge createDefaultBridge({bool? enablePhysical}) {
    final allowPhysical = enablePhysical ?? enablePhysicalHardware;
    if (allowPhysical) {
      return CompositeHardwareBridge();
    }
    return VirtualSimulationBridge();
  }
}
