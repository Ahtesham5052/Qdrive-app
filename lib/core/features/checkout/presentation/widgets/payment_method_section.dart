import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_payment_provider.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

/// Reusable payment method section.
///
/// Responsibility:
/// - read JSON
/// - prepare selected payment state
/// - pass everything to JsonLayoutRenderer
///
/// Important:
/// Payment-specific UI nodes such as:
/// - payment_option_list
/// - payment_method_tile
/// - payment_radio
/// - payment_provider_pills
/// - payment_card_brands
/// - bnpl_panel
/// - bnpl_provider_cards
/// - payment_schedule_card
/// - payment_benefit_box
///
/// must live inside JsonLayoutRenderer, not here.
class PaymentMethodSection extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const PaymentMethodSection({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = data['id']?.toString() ?? '';

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});
    final classes = ElementSettings.classList(data['classes']);

    final options = _mapList(props['options']);

    final selectedPaymentMap = ref.watch(selectedPaymentMethodProvider);

    final selectedPaymentId =
        selectedPaymentMap[id]?.toString() ??
        props['selectedPaymentId']?.toString() ??
        _defaultSelectedId(options);

    final resolvedOptions = _markSelectedOptions(
      options: options,
      selectedPaymentId: selectedPaymentId,
    );

    final selectedOption = _selectedOption(
      options: resolvedOptions,
      selectedPaymentId: selectedPaymentId,
    );

    final buyNowPayLaterRaw = selectedOption['buyNowPayLater'];

    final buyNowPayLater = buyNowPayLaterRaw is Map
        ? Map<dynamic, dynamic>.from(buyNowPayLaterRaw)
        : null;

    final showBuyNowPayLater = buyNowPayLater != null;

    final layout = _layoutList(config['layout']);

    final renderLayout = layout.isNotEmpty ? layout : _legacyLayout;

    final renderData = <String, dynamic>{
      ...props,

      "id": id,
      "paymentSectionId": id,

      "title": props['title'] ?? '',
      "options": resolvedOptions,

      "selectedPaymentId": selectedPaymentId,
      "selectedOption": selectedOption,

      "buyNowPayLater": buyNowPayLater,
      "showBuyNowPayLater": showBuyNowPayLater,

      "currency": props['currency'] ?? 'GBP',
    };

    return Container(
      width: double.infinity,
      margin: ElementSettings.margin(classes),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: renderLayout.map((node) {
          return JsonLayoutRenderer(
            node: node,
            data: renderData,
            theme: theme,
            config: config,
            currency: renderData['currency']?.toString() ?? 'GBP',
          );
        }).toList(),
      ),
    );
  }

  static List<Map<dynamic, dynamic>> _mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();
  }

  static List<Map<dynamic, dynamic>> _layoutList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();
  }

  static String? _defaultSelectedId(List<Map<dynamic, dynamic>> options) {
    for (final option in options) {
      if (option['selected'] == true) {
        return option['id']?.toString();
      }
    }

    return options.isNotEmpty ? options.first['id']?.toString() : null;
  }

  static List<Map<dynamic, dynamic>> _markSelectedOptions({
    required List<Map<dynamic, dynamic>> options,
    required String? selectedPaymentId,
  }) {
    return options.map((option) {
      final next = Map<dynamic, dynamic>.from(option);
      next['selected'] = next['id']?.toString() == selectedPaymentId;
      return next;
    }).toList();
  }

  static Map<dynamic, dynamic> _selectedOption({
    required List<Map<dynamic, dynamic>> options,
    required String? selectedPaymentId,
  }) {
    for (final option in options) {
      if (option['id']?.toString() == selectedPaymentId) {
        return option;
      }
    }

    return options.isNotEmpty ? options.first : <String, dynamic>{};
  }

  /// Legacy fallback layout.
  ///
  /// This keeps old JSON working even when config.layout is missing.
  /// The UI is still rendered by JsonLayoutRenderer.
  static const List<Map<dynamic, dynamic>> _legacyLayout = [
    {
      "type": "column",
      "crossAxis": "stretch",
      "children": [
        {"type": "text", "key": "title", "themeKey": "title"},
        {
          "type": "payment_option_list",
          "itemsKey": "options",
          "classes": ["mt-md"],
        },
        {
          "type": "bnpl_panel",
          "key": "buyNowPayLater",
          "visibleWhen": "showBuyNowPayLater == true",
          "classes": ["mt-sm"],
        },
      ],
    },
  ];
}
