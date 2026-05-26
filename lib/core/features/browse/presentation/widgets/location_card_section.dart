// ==========================================
// LOCATION CARD SECTION
// Supports both:
// 1. New config.layout JSON renderer format
// 2. Old hardcoded location card fallback
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class LocationCardSection extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const LocationCardSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ========================================
    // Root classes
    // Example: ["mb-xl"]
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Theme from JSON
    // Example:
    // title, card, iconBox, icon,
    // locationTitle, address, hours
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
    // title, icon, locationTitle, address, hours
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    // ========================================
    // New layout-driven rendering
    // ========================================

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

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

    return _legacyLocationCard(
      context: context,
      classes: classes,
      props: props,
      theme: theme,
    );
  }

  // ==========================================
  // OLD LOCATION CARD FALLBACK
  // Keeps older screens working safely.
  // ==========================================

  Widget _legacyLocationCard({
    required BuildContext context,
    required List<String> classes,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
  }) {
    final cardClasses = ElementSettings.classList(theme['card']);

    final iconBoxClasses = ElementSettings.classList(theme['iconBox']);

    final iconClasses = ElementSettings.classList(theme['icon']);

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

            const SizedBox(height: 14),
          ],

          // ==================================
          // Location card
          // ==================================
          Container(
            width: double.infinity,

            padding: ElementSettings.padding(cardClasses),

            decoration: ElementSettings.decoration(context, cardClasses),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ==========================
                // Icon box
                // ==========================
                Container(
                  width: 42,
                  height: 42,

                  decoration: ElementSettings.decoration(
                    context,
                    iconBoxClasses,
                  ),

                  child: Center(
                    child: ElementIcons.show(
                      context,
                      props['icon'],
                      size: 20,
                      color: ElementSettings.textColor(context, iconClasses),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // ==========================
                // Location text content
                // ==========================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        props['locationTitle'] ?? '',
                        style: ElementSettings.textStyle(
                          context,
                          ElementSettings.classList(theme['locationTitle']),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        props['address'] ?? '',
                        style: ElementSettings.textStyle(
                          context,
                          ElementSettings.classList(theme['address']),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        props['hours'] ?? '',
                        style: ElementSettings.textStyle(
                          context,
                          ElementSettings.classList(theme['hours']),
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
