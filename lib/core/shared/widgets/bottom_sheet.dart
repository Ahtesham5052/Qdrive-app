// lib/core/navigation/qdrive_bottom_sheet.dart

import 'package:Qdrive/core/engine/renderer/element_renderer.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/engine/screen/screen_builder.dart';
import 'package:flutter/material.dart';

class QDriveBottomSheet {
  static Future<T?> openScreen<T>({
    required BuildContext context,
    required Map<dynamic, dynamic> json,

    /// Pass the parent/root screen JSON when opening an embedded tray.
    /// This lets actionRef inside the tray resolve from the parent screen actions.
    Map<dynamic, dynamic>? currentScreenJson,
  }) {
    final safeJson = _deepStringMap(json);
    final safeRootJson = currentScreenJson == null
        ? null
        : _deepStringMap(currentScreenJson);

    final resolvedJson = _resolveEmbeddedActionRefs(
      json: safeJson,
      rootJson: safeRootJson,
    );

    final bool isFullScreenJson = resolvedJson['ui'] is Map;
    final bool isBodyJson = resolvedJson['body'] is Map;
    final bool isSingleNodeJson = resolvedJson['type'] is String;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final double heightFactor = resolvedJson['maxHeightFactor'] is num
            ? (resolvedJson['maxHeightFactor'] as num).toDouble().clamp(
                0.45,
                0.98,
              )
            : 0.92;

        if (isFullScreenJson) {
          return _SheetFrame(
            heightFactor: heightFactor,
            child: _BottomSheetShell(
              title: _readScreenTitle(resolvedJson),
              subtitle: _readScreenSubtitle(resolvedJson),
              child: ScreenBuilder(json: resolvedJson),
            ),
          );
        }

        if (isBodyJson) {
          return _SheetFrame(
            heightFactor: heightFactor,
            child: _BodyJsonBottomSheet(json: resolvedJson),
          );
        }

        if (isSingleNodeJson) {
          return _SheetFrame(
            heightFactor: heightFactor,
            child: _SingleNodeBottomSheet(json: resolvedJson),
          );
        }

        return _SheetFrame(
          heightFactor: heightFactor,
          child: _BottomSheetShell(
            title: _readScreenTitle(resolvedJson),
            subtitle: _readScreenSubtitle(resolvedJson),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              child: ElementRenderer(data: resolvedJson),
            ),
          ),
        );
      },
    );
  }

  static String _readScreenTitle(Map<String, dynamic> json) {
    final title = json['title']?.toString();

    if (title != null && title.isNotEmpty) {
      return title;
    }

    final content = json['content'];

    if (content is Map && content['header'] is Map) {
      final header = Map<String, dynamic>.from(content['header']);
      return header['title']?.toString() ?? '';
    }

    return '';
  }

  static String _readScreenSubtitle(Map<String, dynamic> json) {
    final subtitle = json['subtitle']?.toString();

    if (subtitle != null && subtitle.isNotEmpty) {
      return subtitle;
    }

    final content = json['content'];

    if (content is Map && content['header'] is Map) {
      final header = Map<String, dynamic>.from(content['header']);
      return header['subtitle']?.toString() ?? '';
    }

    return '';
  }

  static Map<String, dynamic> _resolveEmbeddedActionRefs({
    required Map<String, dynamic> json,
    required Map<String, dynamic>? rootJson,
  }) {
    final actions = <String, dynamic>{
      if (rootJson?['actions'] is Map)
        ...Map<String, dynamic>.from(rootJson!['actions']),
      if (json['actions'] is Map) ...Map<String, dynamic>.from(json['actions']),
    };

    if (actions.isEmpty) {
      return Map<String, dynamic>.from(json);
    }

    final resolved = _resolveActionRefsDeep(json, actions);

    if (resolved is Map<String, dynamic>) {
      return resolved;
    }

    if (resolved is Map) {
      return Map<String, dynamic>.from(resolved);
    }

    return Map<String, dynamic>.from(json);
  }

  static dynamic _resolveActionRefsDeep(
    dynamic value,
    Map<String, dynamic> actions,
  ) {
    if (value is List) {
      return value.map((item) {
        return _resolveActionRefsDeep(item, actions);
      }).toList();
    }

    if (value is Map) {
      final map = Map<String, dynamic>.from(value);

      final actionRef = map['actionRef'];

      if (actionRef is String &&
          actionRef.isNotEmpty &&
          map['action'] == null &&
          actions[actionRef] != null) {
        map['action'] = _copyAction(actions[actionRef]);
        map.remove('actionRef');
      }

      return map.map((key, child) {
        return MapEntry(key.toString(), _resolveActionRefsDeep(child, actions));
      });
    }

    return value;
  }

  static Map<String, dynamic> _copyAction(dynamic actionData) {
    if (actionData is Map<String, dynamic>) {
      return Map<String, dynamic>.from(actionData);
    }

    if (actionData is Map) {
      return Map<String, dynamic>.from(actionData);
    }

    return <String, dynamic>{};
  }

  static Map<String, dynamic> _deepStringMap(Map<dynamic, dynamic> input) {
    dynamic convert(dynamic value) {
      if (value is Map) {
        return value.map(
          (key, child) => MapEntry(key.toString(), convert(child)),
        );
      }

      if (value is List) {
        return value.map(convert).toList();
      }

      return value;
    }

    return Map<String, dynamic>.from(convert(input));
  }
}

class _SheetFrame extends StatelessWidget {
  final double heightFactor;
  final Widget child;

  const _SheetFrame({required this.heightFactor, required this.child});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: child,
      ),
    );
  }
}

class _BodyJsonBottomSheet extends StatelessWidget {
  final Map<String, dynamic> json;

  const _BodyJsonBottomSheet({required this.json});

  @override
  Widget build(BuildContext context) {
    final title = json['title']?.toString() ?? '';
    final subtitle = json['subtitle']?.toString() ?? '';

    final body = json['body'] is Map
        ? Map<String, dynamic>.from(json['body'])
        : <String, dynamic>{};

    return _BottomSheetShell(
      title: title,
      subtitle: subtitle,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        child: _JsonBodyRenderer(node: body),
      ),
    );
  }
}

class _SingleNodeBottomSheet extends StatelessWidget {
  final Map<String, dynamic> json;

  const _SingleNodeBottomSheet({required this.json});

  @override
  Widget build(BuildContext context) {
    final title = json['title']?.toString() ?? '';
    final subtitle = json['subtitle']?.toString() ?? '';

    return _BottomSheetShell(
      title: title,
      subtitle: subtitle,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        child: _JsonBodyRenderer(node: json),
      ),
    );
  }
}

class _JsonBodyRenderer extends StatelessWidget {
  final Map<String, dynamic> node;

  const _JsonBodyRenderer({required this.node});

  @override
  Widget build(BuildContext context) {
    if (node.isEmpty) {
      return const SizedBox.shrink();
    }

    if (node['type'] is String) {
      final props = node['props'] is Map
          ? Map<String, dynamic>.from(node['props'])
          : <String, dynamic>{};

      final theme = node['theme'] is Map
          ? Map<String, dynamic>.from(node['theme'])
          : <String, dynamic>{};

      final config = node['config'] is Map
          ? Map<String, dynamic>.from(node['config'])
          : <String, dynamic>{};

      return JsonLayoutRenderer(
        node: node,
        data: props,
        theme: theme,
        config: config,
        currency: 'GBP',
      );
    }

    return ElementRenderer(data: node);
  }
}

class _BottomSheetShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _BottomSheetShell({
    this.title = '',
    this.subtitle = '',
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF151515)
        : const Color(0xFFFFFFFF);

    final borderColor = isDark
        ? const Color(0xFF242424)
        : const Color(0xFFE5E5E5);

    final titleColor = isDark
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF111111);

    final mutedColor = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    final buttonBackground = isDark
        ? const Color(0xFF171717)
        : const Color(0xFFF3F4F6);

    final dragHandleColor = isDark
        ? const Color(0xFF3F3F46)
        : const Color(0xFFD1D5DB);

    return Material(
      color: backgroundColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Column(
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: dragHandleColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: title.isEmpty && subtitle.isEmpty
                          ? const SizedBox(height: 38)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (title.isNotEmpty)
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: titleColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      height: 1.2,
                                    ),
                                  ),

                                if (subtitle.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: mutedColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                    ),

                    const SizedBox(width: 12),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).maybePop();
                      },
                      child: Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: buttonBackground,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                        ),
                        child: Icon(Icons.close, size: 20, color: titleColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(child: child),
        ],
      ),
    );
  }
}
