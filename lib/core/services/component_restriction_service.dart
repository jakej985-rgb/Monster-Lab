import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/component_model.dart';
import 'parent_session_service.dart';

class ComponentRestrictionService {
  static const String _storagePrefix = 'monster_lab_restricted_unlocks_';
  final SharedPreferences? _prefs;

  final Map<String, Set<String>> _inMemoryUnlocks = {};

  ComponentRestrictionService([this._prefs]);

  static Future<ComponentRestrictionService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ComponentRestrictionService(prefs);
  }

  bool isRestricted(ComponentModel component) {
    return component.safety.requiresParentUnlock ||
        component.safety.level == SafetyLevel.restrictedAdultSupervision;
  }

  bool isUnlocked(String componentId, String learnerId) {
    final cached = _inMemoryUnlocks[learnerId];
    if (cached != null && cached.contains(componentId)) {
      return true;
    }

    if (_prefs != null) {
      final key = '$_storagePrefix$learnerId';
      final list = _prefs.getStringList(key);
      if (list != null && list.contains(componentId)) {
        _inMemoryUnlocks.putIfAbsent(learnerId, () => {}).add(componentId);
        return true;
      }
    }

    return false;
  }

  Future<bool> unlockComponent({
    required ComponentModel component,
    required String learnerId,
    required ParentSessionService sessionService,
  }) async {
    // 1. Must be authorized via active, non-expired parent session
    if (!sessionService.isAuthorized) {
      throw const ParentUnauthorizedException(
        'Valid parent authorization session is required to unlock restricted components.',
      );
    }

    // 2. Add to unlocked set
    final set = _inMemoryUnlocks.putIfAbsent(learnerId, () => {});
    set.add(component.id);

    // 3. Persist
    if (_prefs != null) {
      final key = '$_storagePrefix$learnerId';
      await _prefs.setStringList(key, set.toList());
    }

    return true;
  }

  Future<void> revokeUnlock(String componentId, String learnerId) async {
    _inMemoryUnlocks[learnerId]?.remove(componentId);
    if (_prefs != null) {
      final key = '$_storagePrefix$learnerId';
      final set = _inMemoryUnlocks[learnerId] ?? {};
      await _prefs.setStringList(key, set.toList());
    }
  }

  Future<void> revokeAllUnlocks(String learnerId) async {
    _inMemoryUnlocks[learnerId]?.clear();
    if (_prefs != null) {
      final key = '$_storagePrefix$learnerId';
      await _prefs.remove(key);
    }
  }
}
