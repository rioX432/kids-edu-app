import 'package:hive_flutter/hive_flutter.dart';

import 'storage_service.dart';

/// Hive implementation of [StorageService].
///
/// Usage:
/// ```dart
/// final storage = HiveStorageService();
/// await storage.init();
/// await storage.write('key', 'value');
/// final value = await storage.read<String>('key');
/// ```
class HiveStorageService implements StorageService {
  HiveStorageService({this.boxName = 'app_data'});

  final String boxName;
  late Box<dynamic> _box;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(boxName);
    _initialized = true;
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'HiveStorageService not initialized. Call init() first.',
      );
    }
  }

  @override
  Future<T?> read<T>(String key) async {
    _ensureInitialized();
    final value = _box.get(key);
    if (value == null) return null;
    return value as T;
  }

  @override
  Future<void> write<T>(String key, T value) async {
    _ensureInitialized();
    await _box.put(key, value);
  }

  @override
  Future<void> delete(String key) async {
    _ensureInitialized();
    await _box.delete(key);
  }

  @override
  Future<bool> exists(String key) async {
    _ensureInitialized();
    return _box.containsKey(key);
  }

  @override
  Future<List<String>> getAllKeys() async {
    _ensureInitialized();
    return _box.keys.cast<String>().toList();
  }

  @override
  Future<void> clear() async {
    _ensureInitialized();
    await _box.clear();
  }

  @override
  Future<void> close() async {
    if (_initialized) {
      await _box.close();
      _initialized = false;
    }
  }
}
