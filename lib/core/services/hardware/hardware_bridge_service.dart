import 'hardware_bridge.dart';
import 'virtual_simulation_bridge.dart';

class HardwareBridgeService {
  /// Hardware support is simulation-only in this release. The Web Serial
  /// path (`CompositeHardwareBridge`) stays unwired until device-confirmed
  /// safe-state, stable port identity, and unambiguous board matching land.
  static IHardwareBridge createDefaultBridge() {
    return VirtualSimulationBridge();
  }
}
