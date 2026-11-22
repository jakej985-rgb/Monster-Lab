import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/component_model.dart';
import 'parent_session_service.dart';
import 'storage_service.dart';

class ComponentRestrictionService {
  static const String _storagePrefix = 'monster_lab_restricted_unlocks_';
  static const String _safetyPrefix = 'monster_lab_safety_authorization_';
  final SharedPreferences? _prefs;
  final StorageService? _storage;

  final Map<String, Set<String>> _inMemoryUnlocks = {};
  final Map<String, bool> _inMemorySafetyAuthorizations = {};

  ComponentRestrictionService([this._prefs, this._storage]);

  static Future<ComponentRestrictionService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ComponentRestrictionService(prefs);
  }

  bool isRestricted(ComponentModel component) {
    return component.safety.requiresParentUnlock ||
        component.safety.level == SafetyLevel.restrictedAdultSupervision;
  }

  bool isSafetyAuthorized(String safetyKey) {
    final cached = _inMemorySafetyAuthorizations[safetyKey];
    if (cached != null) return cached;

    final storageKey = '$_safetyPrefix$safetyKey';
    final stored = _prefs?.getBool(storageKey) ?? _storage?.getBool(storageKey);
    if (stored != null) {
      _inMemorySafetyAuthorizations[safetyKey] = stored;
      return stored;
    }
    return false;
  }

  Future<void> setSafetyAuthorized(String safetyKey, bool value) async {
    _inMemorySafetyAuthorizations[safetyKey] = value;
    final storageKey = '$_safetyPrefix$safetyKey';
    if (_prefs != null) {
      await _prefs.setBool(storageKey, value);
    } else if (_storage != null) {
      await _storage.setBool(storageKey, value);
    }
  }

  bool isUnlocked(String componentId, String learnerId) {
    final cached = _inMemoryUnlocks[learnerId];
    if (cached != null && cached.contains(componentId)) {
      return true;
    }

    final key = '$_storagePrefix$learnerId';
    final list = _prefs?.getStringList(key) ?? _storage?.getStringList(key);
    if (list != null && list.contains(componentId)) {
      _inMemoryUnlocks.putIfAbsent(learnerId, () => {}).add(componentId);
      return true;
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
    final key = '$_storagePrefix$learnerId';
    if (_prefs != null) {
      await _prefs.setStringList(key, set.toList());
    } else if (_storage != null) {
      await _storage.setStringList(key, set.toList());
    }

    return true;
  }

  Future<void> revokeUnlock(String componentId, String learnerId) async {
    _inMemoryUnlocks[learnerId]?.remove(componentId);
    final key = '$_storagePrefix$learnerId';
    final set = _inMemoryUnlocks[learnerId] ?? {};
    if (_prefs != null) {
      await _prefs.setStringList(key, set.toList());
    } else if (_storage != null) {
      await _storage.setStringList(key, set.toList());
    }
  }

  Future<void> revokeAllUnlocks(String learnerId) async {
    _inMemoryUnlocks[learnerId]?.clear();
    final key = '$_storagePrefix$learnerId';
    if (_prefs != null) {
      await _prefs.remove(key);
    } else if (_storage != null) {
      await _storage.remove(key);
    }
  }
}
