import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

/// Reusable rental period section.
///
/// Rendering priority:
/// 1. Uses `config.layout` when provided.
/// 2. Falls back to the legacy hardcoded rental period layout.
///
/// Supported data:
/// - title
/// - rental date/time fields
/// - duration text
///
/// Important:
/// The `config.layout` path is visual/layout-driven.
/// The legacy fallback keeps the old tappable `_DateField` behaviour.
class RentalPeriodSection extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  /// Creates a rental period section from JSON.
  const RentalPeriodSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ==========================================
    // Root JSON sections
    // ==========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});
    final classes = ElementSettings.classList(data['classes']);

    // ==========================================
    // New JSON layout-driven rendering
    // ==========================================

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    if (layout.isNotEmpty) {
      return _RentalPeriodLayoutRenderer(
        classes: classes,
        props: props,
        theme: theme,
        config: config,
      );
    }

    // ==========================================
    // Legacy fallback rendering
    // ==========================================

    return _RentalPeriodLegacy(classes: classes, props: props, theme: theme);
  }
}

/// Layout-driven rental period renderer.
///
/// This lets JSON control the UI using:
/// - column
/// - row
/// - container
/// - text
/// - icon
/// - for_each
class _RentalPeriodLayoutRenderer extends StatelessWidget {
  final List<String> classes;
  final Map<dynamic, dynamic> props;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;

  const _RentalPeriodLayoutRenderer({
    required this.classes,
    required this.props,
    required this.theme,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    return Container(
      width: double.infinity,
      margin: ElementSettings.margin(classes),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: layout.map((section) {
          return JsonLayoutRenderer(
            node: section,

            // Resolved props become readable JSON data.
            // Example:
            // "key": "title"
            // "itemsKey": "items"
            // "key": "duration"
            data: props,

            // Optional alias for nested usage.
            locals: {"rentalPeriod": props},

            theme: theme,
            config: config,
            currency: props['currency']?.toString() ?? '',
          );
        }).toList(),
      ),
    );
  }
}

/// Legacy rental period layout.
///
/// Used when `config.layout` is missing.
/// This keeps old JSON working safely.
class _RentalPeriodLegacy extends StatelessWidget {
  final List<String> classes;
  final Map<dynamic, dynamic> props;
  final Map<dynamic, dynamic> theme;

  const _RentalPeriodLegacy({
    required this.classes,
    required this.props,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final items = List<Map<dynamic, dynamic>>.from(props['items'] ?? []);

    return Container(
      width: double.infinity,
      margin: ElementSettings.margin(classes),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((props['title'] ?? '').toString().isNotEmpty) ...[
            Text(
              props['title'].toString(),
              style: ElementSettings.textStyle(
                context,
                ElementSettings.classList(theme['title']),
              ),
            ),

            const SizedBox(height: 12),
          ],

          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DateField(item: item, theme: theme),
            );
          }),

          if ((props['duration'] ?? '').toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                props['duration'].toString(),
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['duration']),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// One rental date/time field.
///
/// Used by the legacy fallback.
/// Keeps support for future field actions.
class _DateField extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final Map<dynamic, dynamic> theme;

  const _DateField({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    final fieldClasses = ElementSettings.classList(theme['field']);
    final iconClasses = ElementSettings.classList(theme['icon']);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(),
      child: Container(
        width: double.infinity,
        padding: ElementSettings.padding(fieldClasses),
        decoration: ElementSettings.decoration(context, fieldClasses),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElementIcons.show(
              context,
              item['icon'] ?? 'calendar',
              size: 20,
              color: ElementSettings.textColor(context, iconClasses),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['label']?.toString() ?? '',
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['fieldLabel']),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item['value']?.toString() ?? '',
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['fieldValue']),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles date field tap.
  ///
  /// Direct callbacks run immediately.
  /// Action maps are preserved for your central action handler.
  void _handleTap() {
    final onTap = item['onTap'];

    if (onTap is VoidCallback) {
      onTap();
      return;
    }

    final action = item['action'];

    if (action != null) {
      // Later: connect to your central action handler.
    }
  }
}
