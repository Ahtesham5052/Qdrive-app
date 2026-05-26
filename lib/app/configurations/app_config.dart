// lib/core/config/app_runtime_config.dart

import 'dart:convert';

import 'package:Qdrive/app/configurations/base_api_url.dart';
import 'package:Qdrive/app/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class AppRuntimeConfig {
  static String? homeApiPath;
  static String? menuApiPath;

  static Map<dynamic, dynamic>? rawConfiguration;

  static dynamic homeApiResponse;
  static dynamic menuApiResponse;

  static Map<dynamic, dynamic> configScreens = {};
  static Map<dynamic, dynamic> configDialogs = {};
  static Map<dynamic, dynamic> configTrays = {};
  static Map<dynamic, dynamic>? floatingItem;

  static String? homeApiRawResponse;
  static String? menuApiRawResponse;

  static Future<void> fetchConfigurations() async {
    try {
      debugPrint('================ CONFIG INIT START ================');

      debugPrint('CONFIG API: always fetching fresh');
      await _fetchConfigurationsFromApi();

      debugPrint('CONFIG homeApiPath: $homeApiPath');
      debugPrint('CONFIG menuApiPath: $menuApiPath');

      await fetchHomeApi();
      await fetchMenuApi();

      debugPrint('================ CONFIG INIT END ================');
    } catch (e, stackTrace) {
      debugPrint('================ CONFIG INIT ERROR ================');
      debugPrint('ERROR: $e');
      debugPrint('STACKTRACE: $stackTrace');
      debugPrint('===================================================');
    }
  }

  static Future<void> forceRefreshConfigurations() async {
    debugPrint('================ CONFIG FORCE REFRESH START ================');

    await _fetchConfigurationsFromApi();
    await fetchHomeApi();
    await fetchMenuApi();

    debugPrint('================ CONFIG FORCE REFRESH END ================');
  }

  static Future<void> _fetchConfigurationsFromApi() async {
    try {
      debugPrint('================ CONFIG API FETCH START ================');

      final uri = Uri.parse(_buildApiUrl(configurationEndpoint));

      debugPrint('CONFIG URI: $uri');

      final response = await http.get(
        uri,
        headers: const {'Accept': 'application/json'},
      );

      debugPrint('CONFIG STATUS CODE: ${response.statusCode}');
      debugPrint('CONFIG BODY LENGTH: ${response.body.length}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint('CONFIG API ERROR: ${response.statusCode}');
        debugPrint(
          '================ CONFIG API FETCH END ERROR ================',
        );
        return;
      }

      if (response.body.trim().isEmpty) {
        debugPrint('CONFIG ERROR: Empty configuration response');
        debugPrint(
          '================ CONFIG API FETCH END EMPTY ================',
        );
        return;
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        debugPrint('CONFIG ERROR: Response is not a valid JSON object');
        debugPrint(
          '================ CONFIG API FETCH END INVALID ================',
        );
        return;
      }

      final jsonMap = Map<dynamic, dynamic>.from(decoded);
      final normalisedConfigJson = _normaliseConfigurationJson(jsonMap);

      _hydrateConfigurationRuntimeValues(normalisedConfigJson);

      debugPrint('CONFIG API homeApiPath: $homeApiPath');
      debugPrint('CONFIG API menuApiPath: $menuApiPath');
      debugPrint('CONFIG API screens: ${configScreens.keys.toList()}');
      debugPrint('CONFIG API dialogs: ${configDialogs.keys.toList()}');

      debugPrint(
        '================ CONFIG API FETCH END SUCCESS ================',
      );
    } catch (e, stackTrace) {
      debugPrint('================ CONFIG API FETCH ERROR ================');
      debugPrint('ERROR: $e');
      debugPrint('STACKTRACE: $stackTrace');
      debugPrint('========================================================');
    }
  }

  static Future<bool> fetchHomeApi() async {
    final result = await _fetchConfiguredApi(
      label: 'HOME API',
      path: homeApiPath,
      onSuccess: ({required dynamic decoded, required String rawBody}) {
        homeApiResponse = decoded;
        homeApiRawResponse = rawBody;
      },
    );

    return result;
  }

  static Future<bool> fetchMenuApi() async {
    final result = await _fetchConfiguredApi(
      label: 'MENU API',
      path: menuApiPath,
      onSuccess: ({required dynamic decoded, required String rawBody}) {
        menuApiResponse = decoded;
        menuApiRawResponse = rawBody;
      },
    );

    return result;
  }

  static Future<bool> _fetchConfiguredApi({
    required String label,
    required String? path,
    required void Function({required dynamic decoded, required String rawBody})
    onSuccess,
  }) async {
    try {
      debugPrint('================ $label FETCH START ================');

      final safePath = path?.trim() ?? '';

      if (safePath.isEmpty) {
        debugPrint('$label SKIPPED: path is missing');
        debugPrint(
          '================ $label FETCH END SKIPPED ================',
        );
        return false;
      }

      final uri = Uri.parse(_buildApiUrl(safePath));

      debugPrint('$label PATH: $safePath');
      debugPrint('$label URI: $uri');

      final response = await http.get(
        uri,
        headers: const {'Accept': 'application/json'},
      );

      debugPrint('$label STATUS CODE: ${response.statusCode}');
      debugPrint('$label BODY LENGTH: ${response.body.length}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint('$label ERROR: ${response.statusCode}');
        debugPrint('================ $label FETCH END ERROR ================');
        return false;
      }

      if (response.body.trim().isEmpty) {
        debugPrint('$label ERROR: Empty response');
        debugPrint('================ $label FETCH END EMPTY ================');
        return false;
      }

      final decoded = jsonDecode(response.body);

      onSuccess(decoded: decoded, rawBody: response.body);

      debugPrint('$label RESPONSE SAVED IN AppRuntimeConfig');
      debugPrint('$label RESPONSE TYPE: ${decoded.runtimeType}');

      if (decoded is Map) {
        await cacheApiJsonWithMeta(Map<dynamic, dynamic>.from(decoded));
      } else {
        debugPrint('$label HIVE CACHE SKIPPED: response is not json object');
      }

      debugPrint('================ $label FETCH END SUCCESS ================');

      return true;
    } catch (e, stackTrace) {
      debugPrint('================ $label FETCH ERROR ================');
      debugPrint('ERROR: $e');
      debugPrint('STACKTRACE: $stackTrace');
      debugPrint('====================================================');

      return false;
    }
  }

  static Future<void> cacheApiJsonWithMeta(dynamic decodedJson) async {
    try {
      debugPrint('================ HIVE CACHE START ================');
      debugPrint('DECODED JSON TYPE: ${decodedJson.runtimeType}');

      if (decodedJson is! Map) {
        debugPrint('HIVE SKIPPED: api response is not a json object');
        debugPrint('================ HIVE CACHE END SKIPPED ================');
        return;
      }

      final jsonMap = Map<dynamic, dynamic>.from(decodedJson);

      debugPrint('ROOT KEYS: ${jsonMap.keys.toList()}');

      final metaRaw = jsonMap['meta'];

      debugPrint('META RAW TYPE: ${metaRaw.runtimeType}');
      debugPrint('META RAW: $metaRaw');

      if (metaRaw is! Map) {
        debugPrint('HIVE SKIPPED: meta missing');
        debugPrint('================ HIVE CACHE END SKIPPED ================');
        return;
      }

      final meta = Map<dynamic, dynamic>.from(metaRaw);
      final cacheKey = meta['cacheKey']?.toString().trim() ?? '';
      if (cacheKey == configurationsCacheKey) {
        debugPrint(
          'HIVE SKIPPED: configuration JSON is not cached. '
          'Config API must always be fetched fresh.',
        );
        debugPrint('================ HIVE CACHE END SKIPPED ================');
        return;
      }

      debugPrint('META cacheKey: $cacheKey');
      debugPrint('META cacheWholeJson: ${meta['cacheWholeJson']}');
      debugPrint('META keepCached: ${meta['keepCached']}');

      if (cacheKey.isEmpty) {
        debugPrint('HIVE SKIPPED: meta.cacheKey missing');
        debugPrint('================ HIVE CACHE END SKIPPED ================');
        return;
      }

      final cacheWholeJson = meta['cacheWholeJson'] == true;

      final keepCached = meta['keepCached'] is List
          ? List<String>.from(
              (meta['keepCached'] as List).map((item) => item.toString()),
            )
          : <String>[];

      final Map<dynamic, dynamic> jsonToCache;

      if (cacheWholeJson) {
        jsonToCache = jsonMap;
      } else {
        jsonToCache = <String, dynamic>{
          if (jsonMap.containsKey('version')) 'version': jsonMap['version'],
          if (jsonMap.containsKey('screen')) 'screen': jsonMap['screen'],
          if (jsonMap.containsKey('component'))
            'component': jsonMap['component'],
          'meta': meta,
          for (final key in keepCached)
            if (jsonMap.containsKey(key)) key: jsonMap[key],
        };
      }

      final payload = <String, dynamic>{
        'cacheKey': cacheKey,
        'screen': jsonMap['screen'],
        'component': jsonMap['component'],
        'cachedAt': DateTime.now().toIso8601String(),
        'cacheWholeJson': cacheWholeJson,
        'keepCached': keepCached,
        'json': jsonToCache,
      };

      debugPrint('OPENING HIVE BOX: $cacheKey');

      if (cacheKey == configurationsCacheKey) {
        final configBox = await Hive.openBox<dynamic>(configurationsCacheKey);

        await configBox.put(cacheKey, jsonEncode(payload));

        debugPrint(
          'HIVE CACHED: box=$cacheKey | key=$cacheKey | screen=${jsonMap["screen"]}',
        );
      } else {
        final jsonBox = await Hive.openBox<String>(cacheKey);

        await jsonBox.put(cacheKey, jsonEncode(payload));

        await registerOpenedHiveBox(cacheKey);

        debugPrint(
          'HIVE CACHED: box=$cacheKey | key=$cacheKey | screen=${jsonMap["screen"]} | component=${jsonMap["component"]}',
        );
      }

      debugPrint('================ HIVE CACHE END SUCCESS ================');
    } catch (e, stackTrace) {
      debugPrint('================ HIVE CACHE ERROR ================');
      debugPrint('ERROR: $e');
      debugPrint('STACKTRACE: $stackTrace');
      debugPrint('=================================================');
    }
  }

  static Future<void> registerOpenedHiveBox(String boxName) async {
    try {
      final safeBoxName = boxName.trim();

      if (safeBoxName.isEmpty) {
        debugPrint('HIVE CONFIG SKIPPED: empty box name');
        return;
      }

      if (safeBoxName == configurationsCacheKey) {
        debugPrint(
          'HIVE CONFIG SKIPPED: configurations box should not be added to openedHivesBoxes',
        );
        return;
      }

      final configBox = await Hive.openBox<dynamic>(configurationsCacheKey);
      final existingRaw = configBox.get(openedHivesBoxesKey);

      final openedBoxes = existingRaw is List
          ? existingRaw.map((item) => item.toString()).toSet()
          : <String>{};

      openedBoxes.add(safeBoxName);

      final updatedBoxes = openedBoxes.toList()..sort();

      await configBox.put(openedHivesBoxesKey, updatedBoxes);

      debugPrint('HIVE CONFIG UPDATED: $openedHivesBoxesKey=$updatedBoxes');
    } catch (e, stackTrace) {
      debugPrint('================ HIVE CONFIG ERROR ================');
      debugPrint('ERROR: $e');
      debugPrint('STACKTRACE: $stackTrace');
      debugPrint('==================================================');
    }
  }

  static Future<List<String>> getOpenedHivesBoxes() async {
    try {
      final configBox = await Hive.openBox<dynamic>(configurationsCacheKey);
      final existingRaw = configBox.get(openedHivesBoxesKey);

      if (existingRaw is List) {
        return existingRaw.map((item) => item.toString()).toList();
      }

      return <String>[];
    } catch (e, stackTrace) {
      debugPrint('GET openedHivesBoxes ERROR: $e');
      debugPrint('$stackTrace');
      return <String>[];
    }
  }

  static Future<bool> loadCachedConfiguration() async {
    try {
      debugPrint('================ LOAD CACHED CONFIG START ================');

      final configBox = await Hive.openBox<dynamic>(configurationsCacheKey);
      final cachedRaw = configBox.get(configurationsCacheKey);

      debugPrint('CACHED CONFIG RAW TYPE: ${cachedRaw.runtimeType}');

      if (cachedRaw == null) {
        debugPrint('NO CACHED CONFIG FOUND');
        debugPrint(
          '================ LOAD CACHED CONFIG END EMPTY ================',
        );
        return false;
      }

      final dynamic decodedPayload;

      if (cachedRaw is String) {
        decodedPayload = jsonDecode(cachedRaw);
      } else {
        decodedPayload = cachedRaw;
      }

      if (decodedPayload is! Map) {
        debugPrint('CACHED CONFIG ERROR: cached payload is not map');
        debugPrint(
          '================ LOAD CACHED CONFIG END INVALID ================',
        );
        return false;
      }

      final payloadMap = Map<dynamic, dynamic>.from(decodedPayload);
      final cachedJsonRaw = payloadMap['json'];

      if (cachedJsonRaw is! Map) {
        debugPrint('CACHED CONFIG ERROR: payload.json is not map');
        debugPrint(
          '================ LOAD CACHED CONFIG END INVALID JSON ================',
        );
        return false;
      }

      final cachedJson = Map<dynamic, dynamic>.from(cachedJsonRaw);

      _hydrateConfigurationRuntimeValues(cachedJson);

      debugPrint(
        'LOADED CACHED CONFIG screens: ${configScreens.keys.toList()}',
      );
      debugPrint(
        'LOADED CACHED CONFIG dialogs: ${configDialogs.keys.toList()}',
      );

      if (homeApiPath == null || homeApiPath!.trim().isEmpty) {
        debugPrint('CACHED CONFIG ERROR: homeApiPath missing');
        return false;
      }

      if (menuApiPath == null || menuApiPath!.trim().isEmpty) {
        debugPrint('CACHED CONFIG ERROR: menuApiPath missing');
        return false;
      }

      debugPrint('LOADED CACHED CONFIG homeApiPath: $homeApiPath');
      debugPrint('LOADED CACHED CONFIG menuApiPath: $menuApiPath');
      debugPrint(
        '================ LOAD CACHED CONFIG END SUCCESS ================',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('================ LOAD CACHED CONFIG ERROR ================');
      debugPrint('ERROR: $e');
      debugPrint('STACKTRACE: $stackTrace');
      debugPrint('==========================================================');

      return false;
    }
  }

  static void _hydrateConfigurationRuntimeValues(
    Map<dynamic, dynamic> configurationJson,
  ) {
    rawConfiguration = configurationJson;

    homeApiPath = _findStringKey(configurationJson, 'homeApiPath');
    menuApiPath = _findStringKey(configurationJson, 'menuApiPath');

    configScreens = _readContentMap(configurationJson, 'screens');
    configDialogs = _readContentMap(configurationJson, 'dialogs');
    configTrays = _readContentMap(configurationJson, 'trays');

    final uiRaw = configurationJson['ui'];

    if (uiRaw is Map) {
      final ui = Map<dynamic, dynamic>.from(uiRaw);
      final itemRaw = ui['floatingItem'];

      floatingItem = itemRaw is Map
          ? Map<dynamic, dynamic>.from(itemRaw)
          : null;
    } else {
      floatingItem = null;
    }
  }

  static Map<dynamic, dynamic> _readContentMap(
    Map<dynamic, dynamic> configurationJson,
    String key,
  ) {
    final contentRaw = configurationJson['content'];

    if (contentRaw is! Map) {
      return <String, dynamic>{};
    }

    final content = Map<dynamic, dynamic>.from(contentRaw);
    final value = content[key];

    if (value is Map<dynamic, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<dynamic, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  static Map<dynamic, dynamic>? getConfigTray(String key) {
    final value = configTrays[key];

    if (value is Map<dynamic, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<dynamic, dynamic>.from(value);
    }

    return null;
  }

  static Map<dynamic, dynamic>? getConfigScreen(String key) {
    final value = configScreens[key];

    if (value is Map<dynamic, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<dynamic, dynamic>.from(value);
    }

    return null;
  }

  static Map<dynamic, dynamic>? getConfigDialog(String key) {
    final value = configDialogs[key];

    if (value is Map<dynamic, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<dynamic, dynamic>.from(value);
    }

    return null;
  }

  static Future<void> clearCachedConfiguration() async {
    try {
      debugPrint('================ CLEAR CACHED CONFIG START ================');

      final configBox = await Hive.openBox<dynamic>(configurationsCacheKey);

      await configBox.delete(configurationsCacheKey);

      rawConfiguration = null;
      homeApiPath = null;
      menuApiPath = null;
      configScreens = {};
      configDialogs = {};
      homeApiResponse = null;
      menuApiResponse = null;
      homeApiRawResponse = null;
      menuApiRawResponse = null;
      floatingItem = null;

      debugPrint('CACHED CONFIG DELETED');
      debugPrint('================ CLEAR CACHED CONFIG END ================');
    } catch (e, stackTrace) {
      debugPrint('CLEAR CACHED CONFIG ERROR: $e');
      debugPrint('$stackTrace');
    }
  }

  static Map<dynamic, dynamic> _normaliseConfigurationJson(
    Map<dynamic, dynamic> jsonMap,
  ) {
    final normalised = Map<dynamic, dynamic>.from(jsonMap);

    final metaRaw = normalised['meta'];

    final meta = metaRaw is Map
        ? Map<dynamic, dynamic>.from(metaRaw)
        : <String, dynamic>{};

    meta['cacheKey'] = configurationsCacheKey;
    meta['cacheWholeJson'] = true;

    normalised['meta'] = meta;

    return normalised;
  }

  static String? _findStringKey(dynamic value, String keyName) {
    if (value is Map) {
      final raw = value[keyName];

      if (raw is String && raw.trim().isNotEmpty) {
        return raw.trim();
      }

      for (final child in value.values) {
        final result = _findStringKey(child, keyName);

        if (result != null && result.isNotEmpty) {
          return result;
        }
      }
    }

    if (value is List) {
      for (final child in value) {
        final result = _findStringKey(child, keyName);

        if (result != null && result.isNotEmpty) {
          return result;
        }
      }
    }

    return null;
  }

  static String _buildApiUrl(String endpoint) {
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }

    final cleanBase = baseApiUrl.endsWith('/')
        ? baseApiUrl.substring(0, baseApiUrl.length - 1)
        : baseApiUrl;

    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';

    return '$cleanBase$cleanEndpoint';
  }

  // Add this inside your existing AppRuntimeConfig class.
  // It gives the menu a generic API loader for every menu action with
  // type: "open_remote_json_screen".
  //
  // Required imports in app_config.dart:
  // import 'dart:convert';
  // import 'package:flutter/foundation.dart';
  // import 'package:http/http.dart' as http;

  static final Map<String, Map<dynamic, dynamic>> _remoteJsonScreenCache = {};

  static Future<Map<dynamic, dynamic>> fetchRemoteJsonScreen({
    required String apiPath,
    String apiPathType = 'GET',
    Map<String, dynamic> apiPathData = const {},
    String? cacheKey,
    bool forceRefresh = false,
  }) async {
    final resolvedCacheKey = cacheKey ?? apiPath;

    if (!forceRefresh && _remoteJsonScreenCache.containsKey(resolvedCacheKey)) {
      return _remoteJsonScreenCache[resolvedCacheKey]!;
    }

    // Replace apiBaseUrl with the base URL field already used in your project.
    // Example: http://100.30.214.39:3000
    final uri = Uri.parse('$baseApiUrl$apiPath');
    final method = apiPathType.toUpperCase();

    late final http.Response response;

    if (method == 'POST') {
      response = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(apiPathData),
      );
    } else {
      response = await http.get(uri);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Remote JSON request failed: $method $apiPath -> ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map) {
      throw Exception('Remote JSON response must be an object: $apiPath');
    }

    final json = Map<dynamic, dynamic>.from(decoded);
    _remoteJsonScreenCache[resolvedCacheKey] = json;

    return json;
  }
}
