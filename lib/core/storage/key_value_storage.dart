abstract class KeyValueStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
}

class InMemoryKeyValueStorage implements KeyValueStorage {
  final Map<String, String> _cache = {};

  @override
  Future<String?> read(String key) async => _cache[key];

  @override
  Future<void> write(String key, String value) async {
    _cache[key] = value;
  }
}
