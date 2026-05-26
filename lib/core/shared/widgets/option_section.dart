import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_option_provider.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/shared/widgets/radio_dot.dart';

/// Reusable checkout option section.
///
/// Rendering priority:
/// 1. Uses `config.layout` with JsonLayoutRenderer.
/// 2. Falls back to the legacy hardcoded layout.
///
/// This widget only prepares state/data.
/// Layout primitives are handled by JsonLayoutRenderer.
class OptionSection extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const OptionSection({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ==========================================
    // Root JSON sections
    // ==========================================

    final id = data['id']?.toString() ?? '';
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});
    final classes = ElementSettings.classList(data['classes']);

    // ==========================================
    // Riverpod state
    // ==========================================

    final rawOptions = List<Map<dynamic, dynamic>>.from(props['options'] ?? []);

    final sectionStates = ref.watch(checkoutOptionProvider);
    final sectionState = sectionStates[id];

    final selectedId =
        sectionState?.selectedOptionId ??
        props['selectedValue']?.toString() ??
        _defaultSelectedId(rawOptions);

    final selectedOption = _findOption(rawOptions, selectedId);

    final options = rawOptions.map((option) {
      final optionId = option['id']?.toString() ?? '';
      final selected = optionId == selectedId;

      return {...option, "selected": selected};
    }).toList();

    final calculationData = _buildCalculationData(
      selectedOption: selectedOption,
      state: sectionState,
    );

    final showCalculationPanel =
        selectedOption != null && selectedOption['calculation'] != null;

    // ==========================================
    // Data passed to JsonLayoutRenderer
    // ==========================================

    final renderData = <String, dynamic>{
      ...props,
      "id": id,
      "sectionId": id,
      "title": props['title'] ?? '',
      "options": options,
      "selectedId": selectedId,
      "selectedOption": selectedOption,
      "calculation": calculationData,
      "showCalculationPanel": showCalculationPanel,
    };

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ==========================================
    // Config layout rendering
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
      child: _OptionSectionLegacy(
        id: id,
        data: renderData,
        theme: theme,
        sectionState: sectionState,
      ),
    );
  }

  /// Returns default selected option id.
  static String? _defaultSelectedId(List<Map<dynamic, dynamic>> options) {
    for (final option in options) {
      if (option['selected'] == true) {
        return option['id']?.toString();
      }
    }

    return options.isNotEmpty ? options.first['id']?.toString() : null;
  }

  /// Finds an option by id.
  static Map<dynamic, dynamic>? _findOption(
    List<Map<dynamic, dynamic>> options,
    String? id,
  ) {
    if (id == null) return null;

    for (final option in options) {
      if (option['id']?.toString() == id) {
        return option;
      }
    }

    return null;
  }

  /// Builds calculation data for JsonLayoutRenderer.
  ///
  /// This keeps calculation text dynamic but allows the UI layout
  /// to stay fully controlled by JSON.
  Map<dynamic, dynamic>? _buildCalculationData({
    required Map<dynamic, dynamic>? selectedOption,
    required CheckoutOptionSectionState? state,
  }) {
    if (selectedOption == null || selectedOption['calculation'] == null) {
      return null;
    }

    final calculation = Map<dynamic, dynamic>.from(
      selectedOption['calculation'] ?? {},
    );

    final calculated = state?.calculated == true;
    final distanceMiles = state?.distanceMiles ?? 0;
    final pricePerMile = _toDouble(calculation['pricePerMile']);
    final baseFee = _toDouble(calculation['baseFee']);
    final distanceFee = distanceMiles * pricePerMile;
    final totalFee = state?.fee ?? 0;

    final slots =
        List<Map<dynamic, dynamic>>.from(calculation['timeSlots'] ?? []).map((
          slot,
        ) {
          final slotId = slot['id']?.toString() ?? '';
          final selected = state?.selectedTimeId == slotId;

          return {
            ...slot,
            "selected": selected,
            "slotClasses": selected
                ? calculation['selectedTimeSlotClasses']
                : calculation['timeSlotClasses'],
            "textClasses": selected
                ? calculation['selectedTimeText']
                : calculation['timeText'],
          };
        }).toList();

    return {
      ...calculation,
      "calculated": calculated,
      "selectedOption": selectedOption,
      "baseFeeText":
          "${calculation['baseFeeLabel'] ?? 'Base fee'}: ${_money(baseFee)}",
      "distanceText":
          "${calculation['distanceLabel'] ?? 'Distance'}: ${_formatDistance(distanceMiles)} miles × ${_money(pricePerMile)}/mile = ${_money(distanceFee)}",
      "totalText":
          "${calculation['totalLabel'] ?? 'Total'}: ${_money(totalFee)}",
      "timeSlots": slots,
    };
  }

  /// Converts a value to double safely.
  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0;
  }

  /// Formats GBP money.
  static String _money(double value) {
    if (value % 1 == 0) {
      return '£${value.toStringAsFixed(0)}';
    }

    return '£${value.toStringAsFixed(2)}';
  }

  /// Formats distance without unnecessary decimals.
  static String _formatDistance(double value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(1);
  }
}

/// Legacy option section fallback.
///
/// Used when `config.layout` is missing.
class _OptionSectionLegacy extends ConsumerWidget {
  final String id;
  final Map<dynamic, dynamic> data;
  final Map<dynamic, dynamic> theme;
  final CheckoutOptionSectionState? sectionState;

  const _OptionSectionLegacy({
    required this.id,
    required this.data,
    required this.theme,
    required this.sectionState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = List<Map<dynamic, dynamic>>.from(data['options'] ?? []);

    final selectedOption = data['selectedOption'] is Map
        ? Map<dynamic, dynamic>.from(data['selectedOption'])
        : null;

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

        ...options.map((option) {
          final optionId = option['id']?.toString() ?? '';
          final selected = option['selected'] == true;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LegacyOptionTile(
              option: option,
              theme: theme,
              selected: selected,
              onTap: () {
                ref
                    .read(checkoutOptionProvider.notifier)
                    .selectOption(sectionId: id, optionId: optionId);
              },
            ),
          );
        }),

        if (selectedOption != null && selectedOption['calculation'] != null)
          _LegacyCalculationPanel(
            sectionId: id,
            option: selectedOption,
            theme: theme,
            state: sectionState,
          ),
      ],
    );
  }
}

/// Legacy selectable option tile.
class _LegacyOptionTile extends StatelessWidget {
  final Map<dynamic, dynamic> option;
  final Map<dynamic, dynamic> theme;
  final bool selected;
  final VoidCallback onTap;

  const _LegacyOptionTile({
    required this.option,
    required this.theme,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final optionClasses = ElementSettings.classList(
      selected ? theme['selectedOption'] : theme['option'],
    );

    final radioClasses = ElementSettings.classList(
      selected ? theme['selectedRadio'] : theme['radio'],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: ElementSettings.padding(optionClasses),
        decoration: ElementSettings.decoration(context, optionClasses),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioDot(selected: selected, classes: radioClasses),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option['title']?.toString() ?? '',
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['optionTitle']),
                    ),
                  ),

                  if ((option['description'] ?? '').toString().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      option['description'].toString(),
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['description']),
                      ),
                    ),
                  ],

                  if ((option['price'] ?? '').toString().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      option['price'].toString(),
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['price']),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Legacy calculation panel.
class _LegacyCalculationPanel extends ConsumerWidget {
  final String sectionId;
  final Map<dynamic, dynamic> option;
  final Map<dynamic, dynamic> theme;
  final CheckoutOptionSectionState? state;

  const _LegacyCalculationPanel({
    required this.sectionId,
    required this.option,
    required this.theme,
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculation = Map<dynamic, dynamic>.from(option['calculation'] ?? {});
    final calculated = state?.calculated == true;

    final addressClasses = ElementSettings.classList(
      theme['addressBox'] ?? theme['option'],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          padding: ElementSettings.padding(addressClasses),
          decoration: ElementSettings.decoration(context, addressClasses),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElementIcons.show(
                    context,
                    calculation['addressIcon'] ?? 'location',
                    size: 14,
                    color: ElementSettings.textColor(
                      context,
                      ElementSettings.classList(theme['description']),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      calculation['address']?.toString() ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['optionTitle']),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  ref
                      .read(checkoutOptionProvider.notifier)
                      .calculateDistance(sectionId: sectionId, option: option);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        calculation['successMessage']?.toString() ??
                            'Distance calculated successfully.',
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: ElementSettings.decoration(
                    context,
                    ElementSettings.classList(
                      theme['calculateButton'] ??
                          ['bg-card-soft', 'rounded-md'],
                    ),
                  ),
                  child: Text(
                    calculation['buttonLabel']?.toString() ??
                        'Calculate Distance',
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(
                        theme['calculateButtonLabel'] ??
                            ['text-body', 'text-xs', 'font-bold'],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (calculated && state != null) ...[
          const SizedBox(height: 10),
          _LegacyCostBreakdownPanel(
            sectionId: sectionId,
            calculation: calculation,
            theme: theme,
            state: state!,
          ),
        ],
      ],
    );
  }
}

/// Legacy cost breakdown panel.
class _LegacyCostBreakdownPanel extends ConsumerWidget {
  final String sectionId;
  final Map<dynamic, dynamic> calculation;
  final Map<dynamic, dynamic> theme;
  final CheckoutOptionSectionState state;

  const _LegacyCostBreakdownPanel({
    required this.sectionId,
    required this.calculation,
    required this.theme,
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxClasses = ElementSettings.classList(
      calculation['boxClasses'] ?? theme['calculationBox'],
    );

    final slots = List<Map<dynamic, dynamic>>.from(
      calculation['timeSlots'] ?? [],
    );

    final accentClasses = ElementSettings.classList(
      calculation['accentText'] ?? theme['price'],
    );

    return Container(
      width: double.infinity,
      padding: ElementSettings.padding(boxClasses),
      decoration: ElementSettings.decoration(context, boxClasses),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            calculation['breakdownTitle']?.toString() ?? '',
            style: ElementSettings.textStyle(context, accentClasses),
          ),

          const SizedBox(height: 8),

          Text(
            '${calculation['baseFeeLabel'] ?? 'Base fee'}: '
            '${_money(_toDouble(calculation['baseFee']))}',
            style: ElementSettings.textStyle(context, accentClasses),
          ),

          const SizedBox(height: 4),

          Text(
            '${calculation['distanceLabel'] ?? 'Distance'}: '
            '${_formatDistance(state.distanceMiles)} miles × '
            '${_money(_toDouble(calculation['pricePerMile']))}/mile = '
            '${_money(state.distanceMiles * _toDouble(calculation['pricePerMile']))}',
            style: ElementSettings.textStyle(context, accentClasses),
          ),

          const SizedBox(height: 8),

          Divider(
            color: ElementSettings.borderColor(context, ['border-muted']),
            height: 1,
          ),

          const SizedBox(height: 8),

          Text(
            '${calculation['totalLabel'] ?? 'Total'}: ${_money(state.fee)}',
            style: ElementSettings.textStyle(context, accentClasses),
          ),

          if (slots.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              calculation['timeTitle']?.toString() ?? '',
              style: ElementSettings.textStyle(context, accentClasses),
            ),
            const SizedBox(height: 8),
            Row(
              children: slots.asMap().entries.map((entry) {
                final index = entry.key;
                final slot = entry.value;
                final slotId = slot['id']?.toString() ?? '';
                final selected = state.selectedTimeId == slotId;

                final slotClasses = ElementSettings.classList(
                  selected
                      ? calculation['selectedTimeSlotClasses']
                      : calculation['timeSlotClasses'],
                );

                final textClasses = ElementSettings.classList(
                  selected
                      ? calculation['selectedTimeText']
                      : calculation['timeText'],
                );

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == slots.length - 1 ? 0 : 8,
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ref
                            .read(checkoutOptionProvider.notifier)
                            .selectTime(sectionId: sectionId, timeId: slotId);
                      },
                      child: Container(
                        height: 42,
                        alignment: Alignment.center,
                        decoration: ElementSettings.decoration(
                          context,
                          slotClasses,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slot['label']?.toString() ?? '',
                              style: ElementSettings.textStyle(
                                context,
                                textClasses,
                              ),
                            ),
                            Text(
                              slot['time']?.toString() ?? '',
                              style: ElementSettings.textStyle(
                                context,
                                textClasses,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0;
  }

  String _money(double value) {
    if (value % 1 == 0) return '£${value.toStringAsFixed(0)}';
    return '£${value.toStringAsFixed(2)}';
  }

  String _formatDistance(double value) {
    if (value % 1 == 0) return value.toStringAsFixed(0);
    return value.toStringAsFixed(1);
  }
}
