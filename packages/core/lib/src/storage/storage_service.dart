/// Abstract storage service interface.
///
/// This abstraction allows:
/// - Easy testing with mock implementations
/// - Swapping storage backends (Hive, SharedPreferences, etc.)
/// - Future cloud sync integration
abstract class StorageService {
  /// Initialize the storage service.
  Future<void> init();

  /// Read a value by key.
  Future<T?> read<T>(String key);

  /// Write a value with key.
  Future<void> write<T>(String key, T value);

  /// Delete a value by key.
  Future<void> delete(String key);

  /// Check if a key exists.
  Future<bool> exists(String key);

  /// Get all keys.
  Future<List<String>> getAllKeys();

  /// Clear all data.
  Future<void> clear();

  /// Close the storage connection.
  Future<void> close();
}
