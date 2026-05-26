// ==========================================
// POLICY SECTION
// Supports both:
// 1. New config.layout JSON renderer format
// 2. Old policy list fallback
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class PolicySection extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const PolicySection({super.key, required this.data});

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
    // title, content, item, dotIcon
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
    // title, items
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    // ========================================
    // New JSON layout
    // ========================================

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ========================================
    // Use fully layout-driven rendering
    // when config.layout is available.
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

    return _legacyPolicySection(
      context: context,
      classes: classes,
      props: props,
      theme: theme,
    );
  }

  // ==========================================
  // OLD POLICY SECTION FALLBACK
  // Keeps older screens working safely.
  // ==========================================

  Widget _legacyPolicySection({
    required BuildContext context,
    required List<String> classes,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
  }) {
    final items = List<String>.from(props['items'] ?? []);

    final title = props['title']?.toString() ?? '';

    final contentClasses = ElementSettings.classList(theme['content']);

    final itemClasses = ElementSettings.classList(theme['item']);

    final itemSpacing = ElementSettings.spacingFromClasses(contentClasses);

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
            const SizedBox(height: 14),
          ],

          // ==================================
          // Policy content card
          // ==================================
          Container(
            width: double.infinity,
            padding: ElementSettings.padding(contentClasses),
            decoration: ElementSettings.decoration(context, contentClasses),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(items.length, (index) {
                final isLast = index == items.length - 1;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : itemSpacing),
                  child: Text(
                    '• ${items[index]}',
                    style: ElementSettings.textStyle(context, itemClasses),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
