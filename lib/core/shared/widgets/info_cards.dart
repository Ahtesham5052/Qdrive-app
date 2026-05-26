// ==========================================
// INFO CARD
// Supports:
// 1. New config.layout row/column JSON format
// 2. Icon/title/text/highlight layouts from JSON
// 3. Normal resolved props from JsonResolver
// 4. Old hardcoded fallback if config.layout is missing
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

/// A reusable JSON-driven information card.
///
/// This widget supports two rendering modes:
///
/// 1. New layout-driven mode:
///    Uses `config.layout` and renders row/column/container/text/icon
///    through [JsonLayoutRenderer].
///
/// 2. Legacy fallback mode:
///    Uses the old hardcoded layout when `config.layout` is missing.
///
/// Example supported JSON:
///
/// ```dart
/// {
///   "type": "info_card",
///   "bind": "content.warning",
///   "theme": {...},
///   "config": {
///     "layout": [...]
///   },
///   "props": {
///     "iconKey": "icon",
///     "titleKey": "title",
///     "textKey": "text"
///   }
/// }
/// ```
class InfoCard extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  /// Creates an information card from JSON data.
  const InfoCard({super.key, required this.data});

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
    // card, icon, title, text, highlightText
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
    // icon, title, text, highlightText
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ========================================
    // New layout-driven rendering
    // ========================================

    if (layout.isNotEmpty) {
      return Container(
        margin: ElementSettings.margin(classes),
        child: _buildLayoutDrivenInfoCard(
          context: context,
          props: props,
          layout: layout,
          theme: theme,
          config: config,
        ),
      );
    }

    // ========================================
    // Fallback for old JSON without config.layout
    // ========================================

    return _legacyInfoCard(
      context: context,
      classes: classes,
      props: props,
      theme: theme,
    );
  }

  // ==========================================
  // Builds info card using config.layout
  //
  // This allows JSON like:
  // - container
  // - row
  // - column
  // - icon
  // - text
  //
  // The resolved props are passed as main data,
  // so keys like "icon", "title", "text" work.
  // ==========================================

  Widget _buildLayoutDrivenInfoCard({
    required BuildContext context,
    required Map<dynamic, dynamic> props,
    required List<Map<dynamic, dynamic>> layout,
    required Map<dynamic, dynamic> theme,
    required Map<dynamic, dynamic> config,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: layout.map((section) {
        return JsonLayoutRenderer(
          node: section,

          // Keep resolved props as main data.
          data: props,

          // Also expose props as "info" for optional nested keys.
          locals: {"info": props},

          theme: theme,
          config: config,
          currency: '',
        );
      }).toList(),
    );
  }

  // ==========================================
  // Legacy fallback
  // Keeps old info card JSON working safely.
  // ==========================================

  Widget _legacyInfoCard({
    required BuildContext context,
    required List<String> classes,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
  }) {
    // ========================================
    // Theme class resolution
    // ========================================

    final cardClasses = ElementSettings.classList(theme['card']);
    final iconClasses = ElementSettings.classList(theme['icon']);
    final titleClasses = ElementSettings.classList(theme['title']);
    final textClasses = ElementSettings.classList(theme['text']);
    final highlightClasses = ElementSettings.classList(theme['highlightText']);

    // ========================================
    // Content checks
    // ========================================

    final hasIcon = props['icon'] != null;
    final hasTitle = props['title'] != null;
    final hasHighlightText = props['highlightText'] != null;
    final hasText = props['text'] != null;

    final titleInsideCard = props['titleInsideCard'] == true;

    return Container(
      margin: ElementSettings.margin(classes),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================
          // Optional title above card
          // ==================================
          if (hasTitle && !hasIcon && !titleInsideCard) ...[
            Text(
              props['title']?.toString() ?? '',
              style: ElementSettings.textStyle(context, titleClasses),
            ),
            const SizedBox(height: 10),
          ],

          // ==================================
          // Main card
          // ==================================
          Container(
            width: double.infinity,
            padding: ElementSettings.padding(cardClasses),
            decoration: ElementSettings.decoration(context, cardClasses),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==============================
                // Optional icon
                // ==============================
                if (hasIcon) ...[
                  ElementIcons.show(
                    context,
                    props['icon']?.toString() ?? '',
                    size: 18,
                    color: ElementSettings.textColor(context, iconClasses),
                  ),
                  const SizedBox(width: 10),
                ],

                // ==============================
                // Text content
                // ==============================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ========================
                      // Title inside card
                      // ========================
                      if (hasTitle && (hasIcon || titleInsideCard)) ...[
                        Text(
                          props['title']?.toString() ?? '',
                          style: ElementSettings.textStyle(
                            context,
                            titleClasses,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],

                      // ========================
                      // Highlight text
                      // ========================
                      if (hasHighlightText) ...[
                        Text(
                          props['highlightText']?.toString() ?? '',
                          style: ElementSettings.textStyle(
                            context,
                            highlightClasses,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],

                      // ========================
                      // Body text
                      // ========================
                      if (hasText)
                        Text(
                          props['text']?.toString() ?? '',
                          style: ElementSettings.textStyle(
                            context,
                            textClasses,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
