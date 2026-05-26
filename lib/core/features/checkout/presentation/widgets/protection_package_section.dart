import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_protection_provider.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/shared/widgets/radio_dot.dart';

/// Reusable protection package section.
///
/// Rendering priority:
/// 1. Uses `config.layout` through JsonLayoutRenderer.
/// 2. Falls back to the legacy hardcoded protection package UI.
///
/// This widget only prepares:
/// - selected state
/// - expanded coverage state
/// - option data
///
/// All layout primitives are handled by JsonLayoutRenderer.
class ProtectionPackageSection extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const ProtectionPackageSection({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ==========================================
    // Root JSON sections
    // ==========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});
    final classes = ElementSettings.classList(data['classes']);

    // ==========================================
    // Riverpod state
    // ==========================================

    final rawOptions = List<Map<dynamic, dynamic>>.from(props['options'] ?? []);

    final watchedSelectedId = ref.watch(selectedProtectionProvider);
    final expandedId = ref.watch(expandedProtectionProvider);

    final selectedId = watchedSelectedId ?? _defaultSelectedId(rawOptions);

    // ==========================================
    // Add widget-ready state to every option
    // ==========================================

    final options = rawOptions.map((option) {
      final optionId = option['id']?.toString() ?? '';
      final selected = selectedId == optionId;
      final expanded = expandedId == optionId;

      final coverageItems = List<String>.from(option['coverageItems'] ?? []);

      return {
        ...option,
        "selected": selected,
        "expanded": expanded,
        "coverageItemsBulleted": coverageItems
            .map((item) => '• $item')
            .toList(),
      };
    }).toList();

    // ==========================================
    // Data passed to JsonLayoutRenderer
    // ==========================================

    final renderData = <String, dynamic>{
      ...props,
      "title": props['title'] ?? '',
      "subtitle": props['subtitle'] ?? '',
      "description": props['description'] ?? '',
      "options": options,
      "selectedId": selectedId,
      "expandedId": expandedId,
    };

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ==========================================
    // JSON layout rendering
    // ==========================================

    if (layout.isNotEmpty) {
      return Container(
        width: double.infinity,
        margin: ElementSettings.margin(classes),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: layout.map((node) {
            return JsonLayoutRenderer(
              node: node,
              data: renderData,
              theme: theme,
              config: config,
              currency: renderData['currency']?.toString() ?? '',
            );
          }).toList(),
        ),
      );
    }

    // ==========================================
    // Legacy fallback
    // ==========================================

    return Container(
      width: double.infinity,
      margin: ElementSettings.margin(classes),
      child: _ProtectionPackageLegacy(data: renderData, theme: theme),
    );
  }

  /// Returns default selected option id.
  static String? _defaultSelectedId(List<Map<dynamic, dynamic>> options) {
    for (final option in options) {
      if (option['selected'] == true) {
        return option['id']?.toString();
      }
    }

    return options.isNotEmpty ? options.first['id']?.toString() : null;
  }
}

/// Legacy fallback renderer.
///
/// Used when `config.layout` is missing.
class _ProtectionPackageLegacy extends ConsumerWidget {
  final Map<dynamic, dynamic> data;
  final Map<dynamic, dynamic> theme;

  const _ProtectionPackageLegacy({required this.data, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = List<Map<dynamic, dynamic>>.from(data['options'] ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((data['title'] ?? '').toString().isNotEmpty) ...[
          Text(
            data['title'].toString(),
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['title']),
            ),
          ),
        ],

        if ((data['subtitle'] ?? '').toString().isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            data['subtitle'].toString(),
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['description']),
            ),
          ),
        ],

        if ((data['description'] ?? '').toString().isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            data['description'].toString(),
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['description']),
            ),
          ),
        ],

        const SizedBox(height: 14),

        ...options.map((option) {
          final id = option['id']?.toString() ?? '';
          final selected = option['selected'] == true;
          final expanded = option['expanded'] == true;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LegacyProtectionTile(
              option: option,
              theme: theme,
              selected: selected,
              expanded: expanded,
              onSelect: () {
                ref.read(selectedProtectionProvider.notifier).state = id;
                ref.read(selectedProtectionOptionProvider.notifier).state =
                    option;
              },
              onToggleCoverage: () {
                ref.read(expandedProtectionProvider.notifier).state = expanded
                    ? null
                    : id;
              },
            ),
          );
        }),
      ],
    );
  }
}

/// Legacy selectable protection tile.
class _LegacyProtectionTile extends StatelessWidget {
  final Map<dynamic, dynamic> option;
  final Map<dynamic, dynamic> theme;
  final bool selected;
  final bool expanded;
  final VoidCallback onSelect;
  final VoidCallback onToggleCoverage;

  const _LegacyProtectionTile({
    required this.option,
    required this.theme,
    required this.selected,
    required this.expanded,
    required this.onSelect,
    required this.onToggleCoverage,
  });

  @override
  Widget build(BuildContext context) {
    final optionClasses = ElementSettings.classList(
      selected ? theme['selectedOption'] : theme['option'],
    );

    final radioClasses = ElementSettings.classList(
      selected ? theme['selectedRadio'] : theme['radio'],
    );

    final coverageText = option['coverageText']?.toString() ?? '';
    final coverageItems = List<String>.from(option['coverageItems'] ?? []);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelect,
      child: Container(
        width: double.infinity,
        padding: ElementSettings.padding(optionClasses),
        decoration: ElementSettings.decoration(context, optionClasses),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioDot(selected: selected, classes: radioClasses),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              children: [
                                Text(
                                  option['title']?.toString() ?? '',
                                  style: ElementSettings.textStyle(
                                    context,
                                    ElementSettings.classList(
                                      theme['optionTitle'],
                                    ),
                                  ),
                                ),

                                if ((option['badge'] ?? '')
                                    .toString()
                                    .isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: ElementSettings.decoration(
                                      context,
                                      ElementSettings.classList(theme['badge']),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if ((option['badgeIcon'] ?? '')
                                            .toString()
                                            .isNotEmpty) ...[
                                          ElementIcons.show(
                                            context,
                                            option['badgeIcon'],
                                            size: 8,
                                          ),
                                          const SizedBox(width: 3),
                                        ],
                                        Text(
                                          option['badge'].toString(),
                                          style: ElementSettings.textStyle(
                                            context,
                                            ElementSettings.classList(
                                              theme['badge'],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          if ((option['price'] ?? '').toString().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 2),
                              child: Text(
                                option['price'].toString(),
                                style: ElementSettings.textStyle(
                                  context,
                                  ElementSettings.classList(theme['price']),
                                ),
                              ),
                            ),
                        ],
                      ),

                      if ((option['description'] ?? '')
                          .toString()
                          .isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          option['description'].toString(),
                          style: ElementSettings.textStyle(
                            context,
                            ElementSettings.classList(theme['optionText']),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            if ((option['linkLabel'] ?? '').toString().isNotEmpty) ...[
              const SizedBox(height: 12),

              if (theme['divider'] == true)
                Divider(
                  color: ElementSettings.borderColor(context, ['border-muted']),
                  height: 1,
                ),

              const SizedBox(height: 10),

              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onToggleCoverage,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option['linkLabel'].toString(),
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['link']),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 16,
                      color: ElementSettings.textColor(
                        context,
                        ElementSettings.classList(theme['link']),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (expanded) ...[
              const SizedBox(height: 10),

              if (coverageText.isNotEmpty)
                Text(
                  coverageText,
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(theme['optionText']),
                  ),
                ),

              if (coverageItems.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...coverageItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '• $item',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['optionText']),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
