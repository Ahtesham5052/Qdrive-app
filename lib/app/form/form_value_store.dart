class JsonFormValueStore {
  static final Map<dynamic, dynamic> _values = {};

  static void setValue(String key, dynamic value) {
    final cleanKey = key.trim();

    if (cleanKey.isEmpty) return;

    _values[cleanKey] = value;
  }

  static Map<dynamic, dynamic> get values {
    return Map<dynamic, dynamic>.from(_values);
  }

  static dynamic getValue(String key) {
    return _values[key];
  }

  static void remove(String key) {
    _values.remove(key);
  }

  static void clear() {
    _values.clear();
  }
}
