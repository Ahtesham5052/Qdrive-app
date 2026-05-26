import 'package:Qdrive/core/utils/sorting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/shared/providers/sort_provider.dart';
import 'package:Qdrive/core/shared/providers/vehicle_filter_provider.dart';

class ListCards extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const ListCards({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classes = ElementSettings.classList(data['classes']);
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);
    final currency = props['currency']?.toString() ?? '';

    final selectedSort = ref.watch(sortLabelProvider) ?? 'Relevance';
    final filter = ref.watch(vehicleFilterProvider);

    final rawItems = List<Map<dynamic, dynamic>>.from(props['items'] ?? []);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = ref.read(vehicleFilterCatalogProvider);

      if (!_sameVehicleCatalog(current, rawItems)) {
        ref.read(vehicleFilterCatalogProvider.notifier).state = rawItems;
      }
    });

    final filteredItems = filterVehicleItems(rawItems, filter);
    final items = ListSorter.sort(filteredItems, selectedSort);

    return Container(
      margin: ElementSettings.margin(classes),
      child: Column(
        children: items.map((item) {
          return _ListCardItem(
            item: item,
            theme: theme,
            config: config,
            currency: currency,
            layout: layout,
          );
        }).toList(),
      ),
    );
  }

  bool _sameVehicleCatalog(
    List<Map<dynamic, dynamic>> oldItems,
    List<Map<dynamic, dynamic>> newItems,
  ) {
    if (oldItems.length != newItems.length) return false;

    for (var i = 0; i < oldItems.length; i++) {
      if (oldItems[i]['vehicleId'] != newItems[i]['vehicleId']) {
        return false;
      }
    }

    return true;
  }
}

class _ListCardItem extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;
  final String currency;
  final List<Map<dynamic, dynamic>> layout;

  const _ListCardItem({
    required this.item,
    required this.theme,
    required this.config,
    required this.currency,
    required this.layout,
  });

  @override
  Widget build(BuildContext context) {
    final cardClasses = ElementSettings.classList(theme['card']);

    return Container(
      margin: ElementSettings.margin(cardClasses),
      decoration: ElementSettings.decoration(context, cardClasses),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final action = item['action'];

          if (action is Map) {
            ActionHandler.handle(context, Map<dynamic, dynamic>.from(action));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: layout.map((section) {
            return JsonLayoutRenderer(
              node: section,
              data: item,
              theme: theme,
              config: config,
              currency: currency,
            );
          }).toList(),
        ),
      ),
    );
  }
}
