import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_extras_provider.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

/// Reusable checkout extras selector section.
///
/// Rendering priority:
/// 1. Uses `config.layout` through JsonLayoutRenderer.
/// 2. Falls back to the legacy hardcoded extras selector UI.
///
/// This widget only prepares:
/// - extras data
/// - quantity state
///
/// The plus/minus tap behaviour is handled by JsonLayoutRenderer
/// through the `extra_quantity_button` node.
class ExtrasSelectorSection extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const ExtrasSelectorSection({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ==========================================
    // Root JSON sections
    // ==========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});
    final classes = ElementSettings.classList(data['classes']);

    // ==========================================
    // Riverpod quantity state
    // ==========================================

    final rawItems = List<Map<dynamic, dynamic>>.from(props['items'] ?? []);
    final selectedExtras = ref.watch(checkoutExtrasProvider);

    final items = rawItems.map((item) {
      final id = item['id']?.toString() ?? '';
      final quantity = selectedExtras[id]?.quantity ?? 0;

      return {...item, "quantity": quantity};
    }).toList();

    // ==========================================
    // Data passed to JsonLayoutRenderer
    // ==========================================

    final renderData = <String, dynamic>{
      ...props,
      "title": props['title'] ?? '',
      "items": items,
    };

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ==========================================
    // JSON layout rendering
    // ==========================================

    if (layout.isNotEmpty) {
      return Container(
        width: double.infinity,
        margin: ElementSettings.margin(classes),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: layout.map((node) {
            return JsonLayoutRenderer(
              node: node,
              data: renderData,
              theme: theme,
              config: config,
              currency: renderData['currency']?.toString() ?? '',
            );
          }).toList(),
        ),
      );
    }

    // ==========================================
    // Legacy fallback
    // ==========================================

    return Container(
      width: double.infinity,
      margin: ElementSettings.margin(classes),
      child: _ExtrasSelectorLegacy(data: renderData, theme: theme),
    );
  }
}

/// Legacy fallback renderer.
///
/// Used when `config.layout` is missing.
class _ExtrasSelectorLegacy extends ConsumerWidget {
  final Map<dynamic, dynamic> data;
  final Map<dynamic, dynamic> theme;

  const _ExtrasSelectorLegacy({required this.data, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = List<Map<dynamic, dynamic>>.from(data['items'] ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((data['title'] ?? '').toString().isNotEmpty) ...[
          Text(
            data['title'].toString(),
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['title']),
            ),
          ),
          const SizedBox(height: 12),
        ],

        ...items.map((item) {
          final id = item['id']?.toString() ?? '';
          final quantity = item['quantity'] ?? 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LegacyExtraItemTile(
              item: item,
              theme: theme,
              quantity: quantity,
              onDecrease: () {
                ref.read(checkoutExtrasProvider.notifier).decrease(id);
              },
              onIncrease: () {
                ref.read(checkoutExtrasProvider.notifier).increase(item);
              },
            ),
          );
        }),
      ],
    );
  }
}

/// Legacy extra item tile.
class _LegacyExtraItemTile extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final Map<dynamic, dynamic> theme;
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _LegacyExtraItemTile({
    required this.item,
    required this.theme,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final itemClasses = ElementSettings.classList(theme['item']);
    final buttonClasses = ElementSettings.classList(theme['button']);
    final iconClasses = ElementSettings.classList(theme['buttonIcon']);

    return Container(
      width: double.infinity,
      padding: ElementSettings.padding(itemClasses),
      decoration: ElementSettings.decoration(context, itemClasses),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']?.toString() ?? '',
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(theme['itemTitle']),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['price']?.toString() ?? '',
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(theme['price']),
                  ),
                ),
              ],
            ),
          ),

          _LegacyQtyButton(
            icon: 'minus',
            classes: buttonClasses,
            iconClasses: iconClasses,
            onTap: onDecrease,
          ),

          SizedBox(
            width: 42,
            child: Center(
              child: Text(
                '$quantity',
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['quantity']),
                ),
              ),
            ),
          ),

          _LegacyQtyButton(
            icon: 'plus',
            classes: buttonClasses,
            iconClasses: iconClasses,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

/// Legacy quantity button.
class _LegacyQtyButton extends StatelessWidget {
  final String icon;
  final List<String> classes;
  final List<String> iconClasses;
  final VoidCallback onTap;

  const _LegacyQtyButton({
    required this.icon,
    required this.classes,
    required this.iconClasses,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: ElementSettings.decoration(context, classes),
        child: ElementIcons.show(
          context,
          icon,
          size: 18,
          color: ElementSettings.textColor(context, iconClasses),
        ),
      ),
    );
  }
}
