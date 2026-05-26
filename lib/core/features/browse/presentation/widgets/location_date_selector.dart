// ==========================================
// LOCATION DATE SELECTOR
// ==========================================
//
// Supports two modes:
//
// 1. Default JSON layout mode
//    - Uses JsonLayoutRenderer.
//    - Keeps your old flexible JSON-driven behaviour.
//
// 2. booking_summary_bar mode
//    - Used on vehicle list page.
//    - Shows compact dark summary like:
//      Leeds Bradford Airport
//      Add dates             Return
//    - Tapping anywhere opens vehicle filter sheet.
//    - Values come from vehicleFilterProvider.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/shared/providers/vehicle_filter_provider.dart';

class LocationDateSelector extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const LocationDateSelector({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ========================================
    // JSON root classes
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // JSON theme/config/props
    // ========================================

    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    // ========================================
    // Action resolved from actionRef
    // ========================================

    final action = props['action'];

    // ========================================
    // Variant switch
    // ========================================

    final variant = props['variant']?.toString();

    if (variant == 'booking_summary_bar') {
      return _BookingSummaryBar(
        data: data,
        classes: classes,
        props: props,
        action: action,
      );
    }

    // ========================================
    // Default old JSON-driven fallback
    // ========================================

    final renderData = {...Map<dynamic, dynamic>.from(data), ...props};

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    return Container(
      margin: ElementSettings.margin(classes),
      padding: ElementSettings.padding(classes),
      decoration: ElementSettings.decoration(context, classes),
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

  static void _handleAction(BuildContext context, dynamic action) {
    if (action is Map) {
      ActionHandler.handle(context, Map<dynamic, dynamic>.from(action));
    }
  }
}

// ==========================================
// BOOKING SUMMARY BAR
// ==========================================
//
// This is the compact view shown on the vehicle list screen.
// It matches the screenshot:
// - Location row at top
// - Pickup date and return date below
// - Personal/Business pill on the right
// - Full card opens the filter sheet

class _BookingSummaryBar extends ConsumerWidget {
  final Map<dynamic, dynamic> data;
  final List<String> classes;
  final Map<dynamic, dynamic> props;
  final dynamic action;

  const _BookingSummaryBar({
    required this.data,
    required this.classes,
    required this.props,
    required this.action,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(vehicleFilterProvider);

    final items = List<Map<dynamic, dynamic>>.from(
      data['items'] ?? props['items'] ?? [],
    );

    final pickupLocationFallback = _itemValue(
      items,
      'pickupLocation',
      fallback: 'Enter pickup location',
    );

    final pickupDateFallback = _itemValue(
      items,
      'pickupDate',
      fallback: 'Add dates',
    );

    final returnDateFallback = _itemValue(
      items,
      'returnDate',
      fallback: 'Return',
    );

    final pickupLocation = filter.pickupLocation.trim().isNotEmpty
        ? filter.pickupLocation
        : pickupLocationFallback;

    final pickupDate = filter.pickupDateTime.trim().isNotEmpty
        ? filter.pickupDateTime
        : pickupDateFallback;

    final returnDate = filter.returnDateTime.trim().isNotEmpty
        ? filter.returnDateTime
        : returnDateFallback;

    final accountLabel = filter.accountType == 'business'
        ? 'Business'
        : 'Personal';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleAction(context, action),
      child: Container(
        margin: ElementSettings.margin(classes),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF3A3A3A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================
            // Top row: pickup location + account pill
            // ==================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElementIcons.show(
                  context,
                  'location',
                  size: 16,
                  color: const Color(0xFF9CA3AF),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    pickupLocation,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    accountLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ==================================
            // Bottom row: pickup date + return date
            // ==================================
            Row(
              children: [
                Expanded(
                  child: _SummaryDateItem(icon: 'calendar', label: pickupDate),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: _SummaryDateItem(icon: 'calendar', label: returnDate),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _itemValue(
    List<Map<dynamic, dynamic>> items,
    String key, {
    required String fallback,
  }) {
    for (final item in items) {
      if (item['key']?.toString() == key) {
        final value = item['value']?.toString();

        if (value != null && value.trim().isNotEmpty) {
          return value;
        }

        final label = item['label']?.toString();

        if (label != null && label.trim().isNotEmpty) {
          return label;
        }
      }
    }

    return fallback;
  }

  static void _handleAction(BuildContext context, dynamic action) {
    if (action is Map) {
      ActionHandler.handle(context, Map<dynamic, dynamic>.from(action));
    }
  }
}

// ==========================================
// SUMMARY DATE ITEM
// ==========================================

class _SummaryDateItem extends StatelessWidget {
  final String icon;
  final String label;

  const _SummaryDateItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElementIcons.show(
          context,
          icon,
          size: 15,
          color: const Color(0xFF9CA3AF),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFD1D5DB),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
