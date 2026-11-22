import 'composite_hardware_bridge.dart';
import 'hardware_bridge.dart';

class HardwareBridgeService {
  static IHardwareBridge createDefaultBridge() {
    return CompositeHardwareBridge();
  }
}
