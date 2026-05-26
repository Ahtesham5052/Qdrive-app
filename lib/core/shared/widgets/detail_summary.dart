// ==========================================
// DETAIL SUMMARY
// Fully layout-driven summary widget
// Supports config.layout JSON structure
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class DetailSummary extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const DetailSummary({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ========================================
    // Root utility classes
    // Example: ["mb-lg"]
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Theme from JSON
    // ========================================

    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});

    // ========================================
    // Config from JSON
    // Expected:
    // config.layout = [...]
    // ========================================

    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});

    // ========================================
    // Resolved props from JsonResolver
    // Example:
    // title, subtitle, rating, specs, currency
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    // ========================================
    // Renderer data
    // Merge full widget data + resolved props
    // This keeps it flexible for future values.
    // ========================================

    final renderData = {...Map<dynamic, dynamic>.from(data), ...props};

    // ========================================
    // Layout from JSON
    // Falls back to default layout if config.layout
    // is missing, so old JSON will not break.
    // ========================================

    final layout = List<Map<dynamic, dynamic>>.from(
      config['layout'] ?? _defaultLayout,
    );

    // ========================================
    // Currency passed into JsonLayoutRenderer
    // Useful if summary later adds price_box.
    // ========================================

    final currency = props['currency']?.toString() ?? '';

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
            currency: currency,
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // Default layout
  // Used only when JSON does not provide config.layout.
  // This keeps the widget backwards-compatible.
  // ==========================================

  static const List<Map<dynamic, dynamic>> _defaultLayout = [
    {
      "type": "column",
      "children": [
        {
          "type": "row",
          "crossAxis": "start",
          "children": [
            {
              "type": "column",
              "flex": 1,
              "children": [
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "maxLines": 1,
                  "overflow": "ellipsis",
                },
                {
                  "type": "text",
                  "key": "subtitle",
                  "themeKey": "subtitle",
                  "classes": ["mt-xs"],
                },
              ],
            },
            {
              "type": "rating",
              "key": "rating",
              "classes": ["ml-md"],
              "showReviews": true,
            },
          ],
        },
        {
          "type": "for_each",
          "itemsKey": "specs",
          "itemName": "spec",
          "layout": "wrap",
          "classes": ["mt-lg"],
          "child": {
            "type": "container",
            "classes": ["mr-lg", "mb-sm"],
            "child": {
              "type": "row",
              "crossAxis": "center",
              "children": [
                {"type": "icon", "key": "spec.icon", "themeKey": "specIcon"},
                {
                  "type": "text",
                  "key": "spec.label",
                  "themeKey": "spec",
                  "classes": ["ml-sm"],
                },
              ],
            },
          },
        },
      ],
    },
  ];
}
