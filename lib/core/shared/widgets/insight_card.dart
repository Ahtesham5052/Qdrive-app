// ==========================================
// INSIGHT CARD
// Fully layout-driven widget
// Supports config.layout JSON structure
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class InsightCard extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const InsightCard({super.key, required this.data});

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
    // card, iconBox, icon, titleIcon, title, text
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
    // icon, titleIcon, title, text, linkLabel
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    // ========================================
    // Renderer data
    // Merge full widget data + resolved props
    // so both direct and resolved values work.
    // ========================================

    final renderData = {...Map<dynamic, dynamic>.from(data), ...props};

    // ========================================
    // Layout from JSON
    // Uses fallback only if config.layout is missing.
    // ========================================

    final layout = List<Map<dynamic, dynamic>>.from(
      config['layout'] ?? _defaultLayout,
    );

    // ========================================
    // Thin render shell only
    // Actual structure is controlled by JSON.
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
            currency: '',
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
        {
          "type": "row",
          "crossAxis": "center",
          "visibleWhen": "sectionTitle != null",
          "classes": ["mb-sm"],
          "children": [
            {"type": "icon", "key": "sectionIcon", "themeKey": "sectionIcon"},
            {
              "type": "text",
              "key": "sectionTitle",
              "themeKey": "sectionTitle",
              "classes": ["ml-sm"],
              "flex": 1,
            },
          ],
        },
        {
          "type": "container",
          "themeKey": "card",
          "child": {
            "type": "row",
            "crossAxis": "start",
            "children": [
              {
                "type": "container",
                "themeKey": "iconBox",
                "child": {"type": "icon", "key": "icon", "themeKey": "icon"},
              },
              {
                "type": "column",
                "flex": 1,
                "classes": ["ml-md"],
                "children": [
                  {
                    "type": "row",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "icon",
                        "key": "titleIcon",
                        "themeKey": "titleIcon",
                        "visibleWhen": "titleIcon != null",
                      },
                      {
                        "type": "text",
                        "key": "title",
                        "themeKey": "title",
                        "classes": ["ml-sm"],
                        "flex": 1,
                      },
                    ],
                  },
                  {
                    "type": "text",
                    "key": "text",
                    "themeKey": "text",
                    "classes": ["mt-sm"],
                  },
                  {
                    "type": "text",
                    "key": "linkLabel",
                    "themeKey": "link",
                    "classes": ["mt-md"],
                    "visibleWhen": "linkLabel != null",
                  },
                ],
              },
            ],
          },
        },
      ],
    },
  ];
}
