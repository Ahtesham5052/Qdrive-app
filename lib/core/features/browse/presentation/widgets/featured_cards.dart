import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/utils/currency.dart';

class FeaturedCard extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const FeaturedCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});
    final classes = ElementSettings.classList(data['classes']);

    final hasConfigLayout =
        config['layout'] is List && (config['layout'] as List).isNotEmpty;

    return Container(
      margin: ElementSettings.margin(classes),

      // ------------------------------------------------------------
      // NEW JSON LAYOUT RENDERER SUPPORT
      // ------------------------------------------------------------
      // If config.layout exists, the widget becomes fully JSON-driven.
      // This lets you control card structure from JSON without changing
      // Flutter code again.
      //
      // The renderer receives `props` as its main data object, so JSON can use:
      // - items
      // - vehicle.title
      // - vehicle.backgroundImage
      // - vehicle.tags
      // - vehicle.price.value
      //
      // Example:
      // "itemsKey": "items"
      // "key": "vehicle.title"
      // ------------------------------------------------------------
      child: hasConfigLayout
          ? _buildConfigLayout(theme: theme, config: config, props: props)
          // --------------------------------------------------------
          // LEGACY FALLBACK
          // --------------------------------------------------------
          // This keeps old JSON working if config.layout is missing.
          // Do not remove this yet because older screens may still rely
          // on the hard-coded FeaturedCard structure.
          // --------------------------------------------------------
          : _buildLegacyLayout(context: context, props: props, theme: theme),
    );
  }

  Widget _buildConfigLayout({
    required Map<dynamic, dynamic> theme,
    required Map<dynamic, dynamic> config,
    required Map<dynamic, dynamic> props,
  }) {
    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    final currency = props['currency']?.toString() ?? 'GBP';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: layout.map((node) {
        return JsonLayoutRenderer(
          node: node,
          data: props,
          theme: theme,
          config: config,
          currency: currency,
        );
      }).toList(),
    );
  }

  Widget _buildLegacyLayout({
    required BuildContext context,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
  }) {
    final cardClasses = ElementSettings.classList(theme['card']);
    final overlayClasses = ElementSettings.classList(theme['overlay']);

    final items = List<Map<dynamic, dynamic>>.from(props['items'] ?? []);

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: items.map((item) {
        final price = Map<dynamic, dynamic>.from(item['price'] ?? {});

        return Container(
          margin: const EdgeInsets.only(bottom: 18),
          decoration: ElementSettings.decoration(context, cardClasses),
          child: ClipRRect(
            borderRadius: ElementSettings.radius(cardClasses),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    item['backgroundImage']?.toString() ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(color: Colors.black12);
                    },
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    color: ElementSettings.background(context, overlayClasses),
                  ),
                ),

                Padding(
                  padding: ElementSettings.padding(cardClasses),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']?.toString() ?? '',
                                  style: ElementSettings.textStyle(
                                    context,
                                    ElementSettings.classList(theme['title']),
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  item['category']?.toString() ?? '',
                                  style: ElementSettings.textStyle(
                                    context,
                                    ElementSettings.classList(
                                      theme['category'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${currencySymbol(price['currency'] ?? 'GBP')}${price['value'] ?? ''}${price['suffix'] ?? ''}',
                                style: ElementSettings.textStyle(
                                  context,
                                  ElementSettings.classList(theme['price']),
                                ),
                              ),

                              if (price['label'] != null)
                                Text(
                                  price['label'].toString(),
                                  style: ElementSettings.textStyle(
                                    context,
                                    ElementSettings.classList(
                                      theme['priceSuffix'],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item['image']?.toString() ?? '',
                            width: 220,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                width: 220,
                                height: 140,
                                color: Colors.black12,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.directions_car,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            List<Map<dynamic, dynamic>>.from(
                              item['tags'] ?? [],
                            ).map((tag) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElementIcons.show(
                                    context,
                                    tag['icon'],
                                    size: 16,
                                    color: ElementSettings.textColor(
                                      context,
                                      ElementSettings.classList(
                                        theme['tagIcon'],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 4),

                                  Text(
                                    tag['label']?.toString() ?? '',
                                    style: ElementSettings.textStyle(
                                      context,
                                      ElementSettings.classList(theme['tag']),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: ElementSettings.padding(
                          ElementSettings.classList(theme['button']),
                        ),
                        decoration: ElementSettings.decoration(
                          context,
                          ElementSettings.classList(theme['button']),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item['buttonLabel']?.toString() ?? 'Rent this car',
                          style: ElementSettings.textStyle(
                            context,
                            ElementSettings.classList(theme['buttonLabel']),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
