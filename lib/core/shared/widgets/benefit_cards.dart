import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

/// Reusable JSON-driven benefit/detail cards.
///
/// Rendering priority:
/// 1. Uses `config.layout` when provided.
/// 2. Falls back to the legacy hardcoded card layout when `config.layout` is empty.
///
/// Supported legacy behaviour:
/// - section title using `props.title`
/// - wide screens show cards in a row
/// - small screens show cards in a column
/// - forced vertical layout using `props.layout: "vertical"`
/// - row card layout using `theme.itemLayout: "row"`
/// - optional `subDescription`
class BenefitCards extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const BenefitCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ==========================================
    // Root data
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
      return _BenefitCardsLayoutRenderer(
        classes: classes,
        props: props,
        theme: theme,
        config: config,
      );
    }

    // ==========================================
    // Legacy fallback rendering
    // ==========================================

    return _BenefitCardsLegacy(classes: classes, props: props, theme: theme);
  }
}

/// Layout-driven renderer for benefit cards.
///
/// This allows the widget to be controlled fully from JSON:
/// - container
/// - row
/// - column
/// - text
/// - icon
/// - for_each
///
/// Important:
/// The outer column uses `CrossAxisAlignment.stretch`,
/// so root containers inside `config.layout` can take full width
/// without needing a custom `fullWidth` property.
class _BenefitCardsLayoutRenderer extends StatelessWidget {
  final List<String> classes;
  final Map<dynamic, dynamic> props;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;

  const _BenefitCardsLayoutRenderer({
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

            // Resolved props become the main readable data.
            // Example:
            // "key": "title"
            // "itemsKey": "items"
            data: props,

            // Optional local alias for advanced nested usage.
            locals: {"benefit": props},

            theme: theme,
            config: config,
            currency: props['currency']?.toString() ?? '',
          );
        }).toList(),
      ),
    );
  }
}

/// Legacy fallback for older JSON.
///
/// This keeps existing benefit card JSON working safely
/// when `config.layout` is not provided.
class _BenefitCardsLegacy extends StatelessWidget {
  final List<String> classes;
  final Map<dynamic, dynamic> props;
  final Map<dynamic, dynamic> theme;

  const _BenefitCardsLegacy({
    required this.classes,
    required this.props,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final items = List<Map<dynamic, dynamic>>.from(props['items'] ?? []);
    final forceVertical = props['layout'] == 'vertical';

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
            const SizedBox(height: 10),
          ],

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 620;

              if (isWide && !forceVertical) {
                return Row(
                  children: items.map((item) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: _BenefitCard(item: item, theme: theme),
                      ),
                    );
                  }).toList(),
                );
              }

              return Column(
                children: items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _BenefitCard(item: item, theme: theme),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Single benefit/detail card used by the legacy fallback.
///
/// Default layout:
/// - icon on top
/// - title below
/// - description below
///
/// Row layout:
/// Uses `theme.itemLayout: "row"`.
class _BenefitCard extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final Map<dynamic, dynamic> theme;

  const _BenefitCard({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    final cardClasses = ElementSettings.classList(theme['card']);
    final iconBoxClasses = ElementSettings.classList(theme['iconBox']);
    final itemLayout = theme['itemLayout']?.toString();

    if (itemLayout == 'row') {
      return _BenefitCardRow(
        item: item,
        theme: theme,
        cardClasses: cardClasses,
        iconBoxClasses: iconBoxClasses,
      );
    }

    return _BenefitCardColumn(
      item: item,
      theme: theme,
      cardClasses: cardClasses,
      iconBoxClasses: iconBoxClasses,
    );
  }
}

/// Legacy row-style card.
///
/// Used for detail rows like:
/// - Vehicle
/// - Rental Period
/// - Pickup Location
class _BenefitCardRow extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final Map<dynamic, dynamic> theme;
  final List<String> cardClasses;
  final List<String> iconBoxClasses;

  const _BenefitCardRow({
    required this.item,
    required this.theme,
    required this.cardClasses,
    required this.iconBoxClasses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ElementSettings.padding(cardClasses),
      decoration: ElementSettings.decoration(context, cardClasses),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: ElementSettings.decoration(context, iconBoxClasses),
            child: Center(
              child: ElementIcons.show(
                context,
                item['icon'],
                size: 15,
                color: ElementSettings.textColor(
                  context,
                  ElementSettings.classList(theme['icon']),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']?.toString() ?? '',
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(
                      theme['titleText'] ?? theme['title'],
                    ),
                  ),
                ),

                if ((item['description'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item['description'].toString(),
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['description']),
                    ),
                  ),
                ],

                if ((item['subDescription'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item['subDescription'].toString(),
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['subDescription']),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Legacy column-style card.
///
/// Used for classic benefit cards:
/// - icon
/// - title
/// - description
class _BenefitCardColumn extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final Map<dynamic, dynamic> theme;
  final List<String> cardClasses;
  final List<String> iconBoxClasses;

  const _BenefitCardColumn({
    required this.item,
    required this.theme,
    required this.cardClasses,
    required this.iconBoxClasses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ElementSettings.padding(cardClasses),
      decoration: ElementSettings.decoration(context, cardClasses),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: ElementSettings.decoration(context, iconBoxClasses),
            child: Center(
              child: ElementIcons.show(
                context,
                item['icon'],
                size: 16,
                color: ElementSettings.textColor(
                  context,
                  ElementSettings.classList(theme['icon']),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            item['title']?.toString() ?? '',
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['title']),
            ),
          ),

          if ((item['description'] ?? '').toString().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item['description'].toString(),
              style: ElementSettings.textStyle(
                context,
                ElementSettings.classList(theme['description']),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
