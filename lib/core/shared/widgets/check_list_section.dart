// ==========================================
// CHECK LIST SECTION
// Supports both:
// 1. New config.layout JSON renderer format
// 2. Old hardcoded checklist fallback
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class CheckListSection extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const CheckListSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ========================================
    // Root classes
    // Example: ["mb-lg"]
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Theme from JSON
    // Example:
    // title, content, itemIconBox, itemIcon, itemText
    // ========================================

    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});

    // ========================================
    // Config from JSON
    // New architecture expects:
    // config.layout = [...]
    // ========================================

    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});

    // ========================================
    // Resolved props from JsonResolver
    // Example:
    // title, itemIcon, items, numbered, markerType
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    // ========================================
    // New JSON layout
    // ========================================

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ========================================
    // If config.layout exists, use new renderer.
    // This matches your vehicle list JSON pattern.
    // ========================================

    if (layout.isNotEmpty) {
      final renderData = {...Map<dynamic, dynamic>.from(data), ...props};

      return Container(
        margin: ElementSettings.margin(classes),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: layout.map((section) {
            return JsonLayoutRenderer(
              node: section,
              data: renderData,
              theme: theme,
              config: config,
              currency: '',
            );
          }).toList(),
        ),
      );
    }

    // ========================================
    // Fallback for old JSON without config.layout
    // ========================================

    return _legacyChecklist(
      context: context,
      classes: classes,
      props: props,
      theme: theme,
    );
  }

  // ==========================================
  // OLD CHECKLIST FALLBACK
  // Keeps old screens working while new screens
  // move to config.layout.
  // ==========================================

  Widget _legacyChecklist({
    required BuildContext context,
    required List<String> classes,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
  }) {
    final items = List<String>.from(props['items'] ?? []);

    final numbered = props['numbered'] == true;

    final markerType = props['markerType']?.toString();

    final contentClasses = ElementSettings.classList(theme['content']);

    final iconBoxClasses = ElementSettings.classList(theme['itemIconBox']);

    final iconClasses = ElementSettings.classList(theme['itemIcon']);

    final itemTextClasses = ElementSettings.classList(theme['itemText']);

    final title = props['title']?.toString() ?? '';

    return Container(
      margin: ElementSettings.margin(classes),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ==================================
          // Section title
          // ==================================
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: ElementSettings.textStyle(
                context,
                ElementSettings.classList(theme['title']),
              ),
            ),

            const SizedBox(height: 12),
          ],

          // ==================================
          // Optional content wrapper
          // ==================================
          Container(
            width: double.infinity,

            padding: ElementSettings.padding(contentClasses),

            decoration: ElementSettings.decoration(context, contentClasses),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: List.generate(items.length, (index) {
                final isLast = index == items.length - 1;

                final isDot = markerType == 'dot';

                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 10),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // ==================
                      // Marker
                      // Supports:
                      // number / dot / icon
                      // ==================
                      Container(
                        width: isDot ? 8 : 22,
                        height: isDot ? 16 : 22,

                        alignment: Alignment.center,

                        decoration: isDot
                            ? null
                            : ElementSettings.decoration(
                                context,
                                iconBoxClasses,
                              ),

                        child: _buildMarker(
                          context: context,
                          index: index,
                          numbered: numbered,
                          isDot: isDot,
                          props: props,
                          iconClasses: iconClasses,
                        ),
                      ),

                      const SizedBox(width: 6),

                      // ==================
                      // Item text
                      // ==================
                      Expanded(
                        child: Text(
                          items[index],
                          style: ElementSettings.textStyle(
                            context,
                            itemTextClasses,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Builds checklist marker
  // ==========================================

  Widget _buildMarker({
    required BuildContext context,
    required int index,
    required bool numbered,
    required bool isDot,
    required Map<dynamic, dynamic> props,
    required List<String> iconClasses,
  }) {
    // ========================================
    // Numbered marker
    // ========================================

    if (numbered) {
      return Text(
        '${index + 1}',
        style: ElementSettings.textStyle(
          context,
          iconClasses,
          size: 10,
          weight: FontWeight.w700,
        ),
      );
    }

    // ========================================
    // Dot marker
    // ========================================

    if (isDot) {
      return Text(
        '•',
        style: ElementSettings.textStyle(
          context,
          iconClasses,
          size: 12,
          weight: FontWeight.w700,
        ),
      );
    }

    // ========================================
    // Icon marker
    // ========================================

    return ElementIcons.show(
      context,
      props['itemIcon'] ?? 'check',
      size: 14,
      color: ElementSettings.textColor(context, iconClasses),
    );
  }
}
