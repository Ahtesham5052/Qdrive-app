// ==========================================
// EXTRAS LIST SECTION
// Fully layout-driven widget
// Supports config.layout JSON structure
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/utils/currency.dart';

class ExtrasListSection extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const ExtrasListSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ========================================
    // Root utility classes
    // Example: ["mb-lg"]
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Theme from JSON
    // Example:
    // title, item, label, price, suffix
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
    // title, currency, suffix, items
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    // ========================================
    // Currency support
    // Creates reusable values for JSON renderer
    // ========================================

    final currencyCode = props['currency']?.toString() ?? '';
    final symbol = currencySymbol(currencyCode);

    // ========================================
    // Renderer data
    // Merge full widget data + resolved props.
    // This allows JSON keys like:
    // title, items, suffix, currencySymbol, pricePrefix
    // ========================================

    final renderData = {
      ...Map<dynamic, dynamic>.from(data),
      ...props,

      // Use this in JSON if you want just "$".
      "currencySymbol": symbol,

      // Use this in JSON if you want "+$".
      "pricePrefix": '+$symbol',
    };

    // ========================================
    // Layout from JSON
    // Falls back to default layout if missing.
    // ========================================

    final layout = List<Map<dynamic, dynamic>>.from(
      config['layout'] ?? _defaultLayout,
    );

    // ========================================
    // Thin render shell only
    // Actual structure comes from JSON.
    // ========================================

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
            currency: currencyCode,
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // Default layout
  // Used only if JSON does not provide config.layout.
  // ==========================================

  static const List<Map<dynamic, dynamic>> _defaultLayout = [
    {
      "type": "column",
      "children": [
        {"type": "text", "key": "title", "themeKey": "title"},
        {
          "type": "for_each",
          "itemsKey": "items",
          "itemName": "extra",
          "layout": "column",
          "classes": ["mt-md"],
          "child": {
            "type": "container",
            "themeKey": "item",
            "classes": ["mb-sm"],
            "child": {
              "type": "row",
              "crossAxis": "center",
              "children": [
                {
                  "type": "text",
                  "key": "extra.label",
                  "themeKey": "label",
                  "flex": 1,
                },
                {
                  "type": "row",
                  "crossAxis": "center",
                  "children": [
                    {"type": "text", "key": "pricePrefix", "themeKey": "price"},
                    {"type": "text", "key": "extra.price", "themeKey": "price"},
                    {"type": "text", "key": "suffix", "themeKey": "suffix"},
                  ],
                },
              ],
            },
          },
        },
      ],
    },
  ];
}
