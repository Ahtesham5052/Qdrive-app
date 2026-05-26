/// Loads JSON screens and refreshes dynamic data when required.
///
/// Rule:
/// - Cached/static layers stay untouched.
/// - Only `dynamicData` refreshes.
/// - If API fails, old `value` or `fallback` remains usable.
class JsonDataLoader {
  const JsonDataLoader();

  Future<Map<dynamic, dynamic>> loadScreenJson(
    Map<dynamic, dynamic> json,
  ) async {
    final meta = Map<dynamic, dynamic>.from(json['meta'] ?? {});
    final refreshOnLoad = List<String>.from(meta['refreshOnLoad'] ?? []);

    var result = Map<dynamic, dynamic>.from(json);

    if (refreshOnLoad.contains('dynamicData')) {
      result = await refreshDynamicData(result);
    }

    return result;
  }

  /// Refreshes only the `dynamicData` section.
  ///
  /// Important:
  /// If fresh API value is `null`, the old value is preserved.
  Future<Map<dynamic, dynamic>> refreshDynamicData(
    Map<dynamic, dynamic> json,
  ) async {
    final result = Map<dynamic, dynamic>.from(json);
    final dynamicData = Map<dynamic, dynamic>.from(result['dynamicData'] ?? {});

    for (final entry in dynamicData.entries) {
      final key = entry.key;
      final config = Map<dynamic, dynamic>.from(entry.value ?? {});

      final source = config['source'];
      final endpoint = config['endpoint'];

      if (source != 'api' || endpoint is! String) {
        continue;
      }

      final freshValue = await _fetchFromApi(endpoint, config['params']);

      dynamicData[key] = {
        ...config,

        // Keep existing value if refresh fails.
        if (freshValue != null) "value": freshValue,
      };
    }

    result['dynamicData'] = dynamicData;
    return result;
  }

  Future<dynamic> _fetchFromApi(String endpoint, dynamic params) async {
    // TODO:
    // Connect with Dio / http / Laravel API later.
    //
    // Return null if API fails.
    // JsonResolver will then use existing value or fallback.

    return null;
  }
}
