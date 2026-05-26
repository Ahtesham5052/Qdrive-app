import 'package:Qdrive/app/theme/provider/app_theme_provider.dart';
import 'package:Qdrive/app/configurations/app_config.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/engine/resolver/json_resolver.dart';
import 'package:Qdrive/core/engine/screen/screen_builder.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';

final qdriveActiveMenuProvider = StateProvider<String?>((ref) => null);

class QDriveAppBar extends ConsumerWidget {
  const QDriveAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = colorScheme.surface;
    final primaryTextColor = colorScheme.onSurface;
    final secondaryTextColor = colorScheme.onSurface.withOpacity(0.65);
    final borderColor = theme.dividerColor.withOpacity(0.5);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
      child: Row(
        children: [
          SvgPicture.string(
            '''
            <svg viewBox="0 0 200 200" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
              <path d="M40 60 L80 40 L160 80 L120 100 Z" opacity="0.95"/>
              <path d="M40 100 L80 80 L160 120 L120 140 Z" opacity="0.7"/>
            </svg>
            ''',
            width: 36,
            height: 36,
            colorFilter: ColorFilter.mode(primaryTextColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Qdrive',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 20,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Drive smarter, arrive happier.',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _openAppMenu(context),
            icon: Icon(Icons.menu, color: primaryTextColor, size: 24),
          ),
        ],
      ),
    );
  }

  Future<void> _openAppMenu(BuildContext context) async {
    Map<dynamic, dynamic>? menuJson = _readMenuJsonFromRuntime();

    if (menuJson == null) {
      debugPrint('MENU JSON missing from AppRuntimeConfig.menuApiResponse');
      debugPrint('Trying to fetch menu API again...');

      await AppRuntimeConfig.fetchMenuApi();

      if (!context.mounted) return;

      menuJson = _readMenuJsonFromRuntime();
    }

    if (menuJson == null) {
      debugPrint('MENU ERROR: menuApiResponse is still empty');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu is not available yet')),
      );

      return;
    }

    final resolved = JsonResolver.resolve(context,menuJson);

    final layout = List<Map<dynamic, dynamic>>.from(
      resolved['ui']?['layout'] ?? [],
    );

    if (layout.isEmpty) {
      debugPrint('MENU ERROR: ui.layout is empty');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Menu layout is missing')));

      return;
    }

    final menuData = _normaliseMenuActionKeys(layout.first);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close menu',
      barrierColor: Colors.black.withOpacity(0.55),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.centerLeft,
          child: SideMenu(data: menuData, menuJson: menuJson!),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  Map<dynamic, dynamic>? _readMenuJsonFromRuntime() {
    final raw = AppRuntimeConfig.menuApiResponse;

    if (raw is Map<dynamic, dynamic>) {
      return raw;
    }

    if (raw is Map) {
      return Map<dynamic, dynamic>.from(raw);
    }

    return null;
  }

  Map<dynamic, dynamic> _normaliseMenuActionKeys(Map<dynamic, dynamic> node) {
    dynamic normalise(dynamic value) {
      if (value is Map) {
        final map = Map<dynamic, dynamic>.from(value);

        if (map['actionRefKey'] != null && map['onTapKey'] == null) {
          map['onTapKey'] = map['actionRefKey'];
        }

        return map.map(
          (key, child) => MapEntry(key.toString(), normalise(child)),
        );
      }

      if (value is List) {
        return value.map(normalise).toList();
      }

      return value;
    }

    return Map<dynamic, dynamic>.from(normalise(node));
  }
}

class SideMenu extends ConsumerWidget {
  final Map<dynamic, dynamic> data;
  final Map<dynamic, dynamic> menuJson;

  const SideMenu({super.key, required this.data, required this.menuJson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});

    final appTheme = Theme.of(context);
    final themeMode = ref.watch(appThemeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final activeActionRef = ref.watch(qdriveActiveMenuProvider);

    final content = _extractMenuContent(menuJson);
    final actions = _extractMenuActions(menuJson);

    final sections = _sectionsWithActiveState(
      List<Map<dynamic, dynamic>>.from(content['sections'] ?? []),
      activeActionRef,
    );

    final panelClasses = ElementSettings.classList(theme['panel']);

    final rendererData = <String, dynamic>{
      'profile': content['profile'],
      'sections': sections,
      'featureCard': content['featureCard'],
      ..._buildMenuActionHandlers(context: context, ref: ref, actions: actions),
    };

    final headerLayout = List<Map<dynamic, dynamic>>.from(
      config['headerLayout'] ?? [],
    );

    final bodyLayout = List<Map<dynamic, dynamic>>.from(
      config['bodyLayout'] ?? [],
    );

    final footerLayout = List<Map<dynamic, dynamic>>.from(
      config['footerLayout'] ?? [],
    );

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 265,
        height: double.infinity,
        child: Container(
          decoration: ElementSettings.decoration(context, panelClasses),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 14, 16),
                  child: _JsonMenuLayout(
                    nodes: headerLayout,
                    data: rendererData,
                    theme: theme,
                    config: config,
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    children: [
                      _JsonMenuLayout(
                        nodes: bodyLayout,
                        data: rendererData,
                        theme: theme,
                        config: config,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 14, 16),
                  child: _JsonMenuLayout(
                    nodes: footerLayout,
                    data: rendererData,
                    theme: theme,
                    config: config,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<dynamic, dynamic> _extractMenuContent(Map<dynamic, dynamic> menuJson) {
    final rawContent = menuJson['content'];

    if (rawContent is! Map) {
      return <String, dynamic>{};
    }

    final content = Map<dynamic, dynamic>.from(rawContent);
    final nestedMenu = content['menu'];

    if (nestedMenu is Map) {
      return Map<dynamic, dynamic>.from(nestedMenu);
    }

    return content;
  }

  Map<String, Map<dynamic, dynamic>> _extractMenuActions(
    Map<dynamic, dynamic> menuJson,
  ) {
    final rawActions = menuJson['actions'];

    if (rawActions is! Map) {
      return <String, Map<dynamic, dynamic>>{};
    }

    return rawActions.map((key, value) {
      final action = value is Map ? Map<dynamic, dynamic>.from(value) : {};
      return MapEntry(key.toString(), action);
    });
  }

  Map<String, VoidCallback> _buildMenuActionHandlers({
    required BuildContext context,
    required WidgetRef ref,
    required Map<String, Map<dynamic, dynamic>> actions,
  }) {
    final handlers = <String, VoidCallback>{};

    for (final entry in actions.entries) {
      handlers[entry.key] = () {
        _handleMenuAction(
          context: context,
          ref: ref,
          actionRef: entry.key,
          actionConfig: entry.value,
        );
      };
    }

    handlers.putIfAbsent('closeMenu', () {
      return () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      };
    });

    return handlers;
  }

  Future<void> _handleMenuAction({
    required BuildContext context,
    required WidgetRef ref,
    required String actionRef,
    required Map<dynamic, dynamic> actionConfig,
  }) async {
    final type = actionConfig['type']?.toString();
    final params = actionConfig['params'] is Map
        ? Map<dynamic, dynamic>.from(actionConfig['params'])
        : <dynamic, dynamic>{};

    switch (type) {
      case 'close_menu':
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        return;

      case 'open_remote_json_screen':
        await _openRemoteJsonScreen(
          context: context,
          ref: ref,
          actionRef: actionRef,
          params: params,
        );
        return;

      default:
        _showSnackBar(context, 'Unsupported menu action: ${type ?? actionRef}');
        return;
    }
  }

  Future<void> _openRemoteJsonScreen({
    required BuildContext context,
    required WidgetRef ref,
    required String actionRef,
    required Map<dynamic, dynamic> params,
  }) async {
    final apiPath = (params['apiPath'] ?? params['api_path'])?.toString();
    final apiPathType =
        (params['apiPathType'] ?? params['api_path_type'] ?? 'GET')
            .toString()
            .toUpperCase();

    final apiPathData = params['apiPathData'] ?? params['api_path_data'] ?? {};
    final cacheKey = params['cacheKey']?.toString() ?? actionRef;

    final rootNavigator = Navigator.of(context, rootNavigator: true);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final container = ProviderScope.containerOf(context, listen: false);

    if (apiPath == null || apiPath.isEmpty) {
      messenger?.showSnackBar(
        SnackBar(content: Text('Missing API path for $actionRef')),
      );
      return;
    }

    final previousActionRef = container.read(qdriveActiveMenuProvider);

    // If the user taps the already-active menu item, just close the menu.
    if (previousActionRef == actionRef) {
      if (rootNavigator.canPop()) {
        rootNavigator.pop();
      }
      return;
    }

    // Update active state immediately.
    container.read(qdriveActiveMenuProvider.notifier).state = actionRef;

    // Close only the menu dialog. Do not use this context after this point.
    if (rootNavigator.canPop()) {
      rootNavigator.pop();
    }

    try {
      final response = await AppRuntimeConfig.fetchRemoteJsonScreen(
        apiPath: apiPath,
        apiPathType: apiPathType,
        apiPathData: apiPathData is Map
            ? Map<String, dynamic>.from(apiPathData)
            : <String, dynamic>{},
        cacheKey: cacheKey,
      );

      final screenJson = _normaliseRemoteScreenResponse(response);

      if (!rootNavigator.mounted) return;

      rootNavigator
          .push(
            MaterialPageRoute(builder: (_) => ScreenBuilder(json: screenJson)),
          )
          .then((_) {
            // When this page is popped, restore the previous menu active state.
            //
            // Example:
            // Search active -> open Blog -> back -> Search becomes active again.
            final currentActive = container.read(qdriveActiveMenuProvider);

            if (currentActive == actionRef) {
              container.read(qdriveActiveMenuProvider.notifier).state =
                  previousActionRef;
            }
          });
    } catch (error, stackTrace) {
      debugPrint('MENU API ERROR for $actionRef ($apiPath): $error');
      debugPrintStack(stackTrace: stackTrace);

      // Restore previous active state if API fails.
      container.read(qdriveActiveMenuProvider.notifier).state =
          previousActionRef;

      messenger?.showSnackBar(
        const SnackBar(content: Text('Unable to open this screen')),
      );
    }
  }

  Map<dynamic, dynamic> _normaliseRemoteScreenResponse(dynamic response) {
    final map = response is Map<dynamic, dynamic>
        ? response
        : response is Map
        ? Map<dynamic, dynamic>.from(response)
        : <dynamic, dynamic>{};

    if (map['ui'] is Map || map['screen'] != null || map['component'] != null) {
      return map;
    }

    final data = map['data'];
    if (data is Map) {
      final dataMap = Map<dynamic, dynamic>.from(data);
      if (dataMap['ui'] is Map ||
          dataMap['screen'] != null ||
          dataMap['component'] != null) {
        return dataMap;
      }
    }

    return map;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  List<Map<dynamic, dynamic>> _sectionsWithActiveState(
    List<Map<dynamic, dynamic>> sections,
    String? activeActionRef,
  ) {
    return sections.map((section) {
      final items = List<Map<dynamic, dynamic>>.from(section['items'] ?? []);

      return {
        ...section,
        'items': items.map((item) {
          return {
            ...item,
            'active':
                activeActionRef != null && item['actionRef'] == activeActionRef,
          };
        }).toList(),
      };
    }).toList();
  }
}

class _JsonMenuLayout extends StatelessWidget {
  final List<Map<dynamic, dynamic>> nodes;
  final Map<dynamic, dynamic> data;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;

  const _JsonMenuLayout({
    required this.nodes,
    required this.data,
    required this.theme,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: nodes.map((node) {
        return JsonLayoutRenderer(
          node: node,
          data: data,
          theme: theme,
          config: config,
          currency: 'GBP',
        );
      }).toList(),
    );
  }
}
