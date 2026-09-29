import 'hardware_bridge.dart';
import 'virtual_simulation_bridge.dart';

class HardwareBridgeService {
  static IHardwareBridge createDefaultBridge() {
    return VirtualSimulationBridge();
  }
}
