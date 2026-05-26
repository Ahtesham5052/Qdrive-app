import 'package:Qdrive/core/features/checkout/providers/checkout_mileage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_extras_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_option_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_payment_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_protection_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_qdrive_pass_provider.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/utils/currency.dart';

/// Reusable JSON-driven price breakdown card.
///
/// Rendering priority:
/// 1. Uses `config.layout` when provided.
/// 2. Falls back to the legacy hardcoded price breakdown UI.
///
/// Keeps existing checkout logic:
/// - delivery fee recalculation
/// - collection fee recalculation
/// - protection package totals
/// - extras totals
/// - QDrive Pass totals
/// - security deposit removal when QDrive Pass is selected
/// - BNPL / Pay in 3 summary mode
/// - due today total
/// - remaining balance note
class PriceBreakdownCard extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  /// Creates a price breakdown card from JSON.
  const PriceBreakdownCard({super.key, required this.data});

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
    // Build computed render data once
    //
    // Both config.layout and legacy fallback use
    // the same final calculated values.
    // ==========================================

    final renderData = _buildRenderData(ref: ref, props: props, theme: theme);

    // ==========================================
    // New JSON layout-driven rendering
    // ==========================================

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    if (layout.isNotEmpty) {
      return _PriceBreakdownShell(
        classes: classes,
        child: _PriceBreakdownLayoutRenderer(
          data: renderData,
          theme: theme,
          config: config,
        ),
      );
    }

    // ==========================================
    // Legacy fallback rendering
    // ==========================================

    return _PriceBreakdownShell(
      classes: classes,
      child: _PriceBreakdownLegacy(data: renderData, theme: theme),
    );
  }

  /// Builds final widget-ready price data.
  ///
  /// Output keys are intentionally simple so JSON can read them directly:
  /// - `title`
  /// - `items`
  /// - `total.label`
  /// - `total.value`
  /// - `note`
  /// - `isBnplSelected`
  /// - `remaining`
  /// - `remainingPayments`
  Map<dynamic, dynamic> _buildRenderData({
    required WidgetRef ref,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
  }) {
    final currency = (props['currency'] ?? 'GBP').toString();

    final selectedProtection = ref.watch(selectedProtectionOptionProvider);
    final selectedExtras = ref.watch(checkoutExtrasProvider);
    final selectedQdrivePass = ref.watch(selectedQdrivePassPlanOptionProvider);
    final selectedMileage = ref.watch(selectedMileageOptionProvider);
    final optionStates = ref.watch(checkoutOptionProvider);

    // ==========================================
    // Payment selection state
    // ==========================================

    final selectedPaymentMap = ref.watch(selectedPaymentMethodProvider);
    final selectedBnplMap = ref.watch(selectedBnplProvider);

    // ==========================================
    // Base data
    // ==========================================

    final items = List<Map<dynamic, dynamic>>.from(props['items'] ?? []);
    final rentalDays = props['rentalDays'] ?? 5;

    final dynamicItems = <Map<dynamic, dynamic>>[];

    double removedSecurityDeposit = 0;
    double serviceFeeDelta = 0;
    double protectionTotal = 0;
    double extrasTotal = 0;
    double mileageTotal = 0;
    double qdrivePassTotal = 0;

    bool hasMileageRow = false;

    // ==========================================
    // Static rows + recalculated service fees
    // ==========================================

    for (final item in items) {
      final isSecurityDeposit = _isSecurityDepositItem(item);
      final label = item['label']?.toString().toLowerCase() ?? '';

      if (label.contains('mileage')) {
        hasMileageRow = true;

        if (selectedMileage != null) {
          final mileageTitle =
              selectedMileage['title']?.toString() ??
              item['label']?.toString() ??
              'Mileage';

          final pricePerDay = _extractPricePerDay(selectedMileage['price']);
          mileageTotal = pricePerDay * rentalDays;

          dynamicItems.add({
            ...item,
            "label": pricePerDay > 0
                ? "$mileageTitle ($rentalDays days)"
                : "Mileage ($mileageTitle)",
            "value": _formatMoney(mileageTotal, currency, forceDecimals: true),
          });

          continue;
        }

        dynamicItems.add({
          ...item,
          "value": _formatDisplayValue(item['value'], currency),
        });

        continue;
      }

      if (!hasMileageRow && selectedMileage != null) {
        final mileageTitle = selectedMileage['title']?.toString() ?? 'Mileage';
        final pricePerDay = _extractPricePerDay(selectedMileage['price']);

        mileageTotal = pricePerDay * rentalDays;

        dynamicItems.add({
          "label": pricePerDay > 0
              ? "$mileageTitle ($rentalDays days)"
              : "Mileage ($mileageTitle)",
          "value": _formatMoney(mileageTotal, currency, forceDecimals: true),
        });
      }

      if (selectedQdrivePass != null && isSecurityDeposit) {
        removedSecurityDeposit += _extractMoney(item['value']);
        continue;
      }

      if (label.contains('delivery fee')) {
        final deliveryState = optionStates['delivery_preference'];

        if (deliveryState?.calculated == true) {
          final oldFee = _extractMoney(item['value']);
          final newFee = deliveryState!.fee;

          serviceFeeDelta += newFee - oldFee;

          dynamicItems.add({...item, "value": _formatMoney(newFee, currency)});

          continue;
        }
      }

      if (label.contains('collection fee')) {
        final collectionState = optionStates['collection_preference'];

        if (collectionState?.calculated == true) {
          final oldFee = _extractMoney(item['value']);
          final newFee = collectionState!.fee;

          serviceFeeDelta += newFee - oldFee;

          dynamicItems.add({...item, "value": _formatMoney(newFee, currency)});

          continue;
        }
      }

      dynamicItems.add({
        ...item,
        "value": _formatDisplayValue(item['value'], currency),
      });
    }

    // ==========================================
    // Protection package total
    // ==========================================

    if (selectedProtection != null) {
      final pricePerDay = _extractPricePerDay(selectedProtection['price']);

      if (pricePerDay > 0) {
        protectionTotal = pricePerDay * rentalDays;

        dynamicItems.add({
          "label": "${selectedProtection['title']} ($rentalDays days)",
          "value": _formatMoney(protectionTotal, currency, forceDecimals: true),
        });
      }
    }

    // ==========================================
    // Extras total
    // ==========================================

    for (final extra in selectedExtras.values) {
      if (extra.quantity <= 0) continue;

      final pricePerDay = _extractPricePerDay(extra.price);

      if (pricePerDay <= 0) continue;

      extrasTotal += pricePerDay * rentalDays * extra.quantity;
    }

    if (extrasTotal > 0) {
      dynamicItems.add({
        "label": "Extras",
        "value": _formatMoney(extrasTotal, currency, forceDecimals: true),
      });
    }

    // ==========================================
    // QDrive Pass total
    // ==========================================

    if (selectedQdrivePass != null) {
      qdrivePassTotal = _extractMoney(selectedQdrivePass['price']);

      dynamicItems.add({
        "label": selectedQdrivePass['title'] ?? 'QDrive Pass',
        "value": _formatDisplayValue(selectedQdrivePass['price'], currency),
        "labelClasses":
            theme['passRowLabel'] ?? ["text-info", "text-xs", "font-bold"],
        "valueClasses":
            theme['passRowValue'] ?? ["text-info", "text-xs", "font-bold"],
      });
    }

    // ==========================================
    // Final total
    // ==========================================

    final total = props['total'] is Map
        ? Map<dynamic, dynamic>.from(props['total'])
        : <String, dynamic>{};

    final baseTotal = _extractMoney(total['value']);

    final finalTotal =
        baseTotal -
        removedSecurityDeposit +
        serviceFeeDelta +
        protectionTotal +
        extrasTotal +
        mileageTotal +
        qdrivePassTotal;

    // ==========================================
    // BNPL / Pay in 3 calculation
    // ==========================================

    final paymentSectionId = props['paymentMethodSectionId']?.toString();

    final installmentPaymentId =
        props['installmentPaymentId']?.toString() ?? 'installments';

    final selectedPaymentId = paymentSectionId == null
        ? null
        : selectedPaymentMap[paymentSectionId];

    final isBnplSelected = selectedPaymentId == installmentPaymentId;

    final selectedProvider = paymentSectionId == null
        ? 'clearpay'
        : selectedBnplMap[paymentSectionId]?.toString() ?? 'clearpay';

    final installmentPayments =
        int.tryParse(props['installmentPayments']?.toString() ?? '') ?? 3;

    final payToday = installmentPayments > 0
        ? finalTotal / installmentPayments
        : finalTotal;

    final remaining = finalTotal - payToday;

    final remainingPayments = installmentPayments > 1
        ? installmentPayments - 1
        : 0;

    // ==========================================
    // Highlight pay-today row
    // ==========================================

    if (isBnplSelected) {
      dynamicItems.add({
        "label": "Pay today (${selectedProvider.toLowerCase()})",
        "value": _formatMoney(payToday, currency, forceDecimals: true),
        "labelClasses":
            theme['highlightLabel'] ?? ["text-info", "text-xs", "font-bold"],
        "valueClasses":
            theme['highlightValue'] ?? ["text-info", "text-xs", "font-bold"],
      });
    }

    final totalLabel = isBnplSelected ? 'Due today' : total['label'] ?? 'Total';

    final totalValue = isBnplSelected ? payToday : finalTotal;

    final remainingNote =
        'Remaining: ${_formatMoney(remaining, currency, forceDecimals: true)} '
        '($remainingPayments payments)';

    final note = isBnplSelected ? remainingNote : props['note']?.toString();

    return {
      ...props,
      "currency": currency,
      "items": dynamicItems,
      "isBnplSelected": isBnplSelected,
      "remaining": _formatMoney(remaining, currency, forceDecimals: true),
      "remainingPayments": remainingPayments,
      "note": note,
      "total": {
        "label": totalLabel,
        "value": _formatMoney(totalValue, currency, forceDecimals: true),
      },
    };
  }

  /// Checks whether a row is a security deposit row.
  bool _isSecurityDepositItem(Map<dynamic, dynamic> item) {
    final id = item['id']?.toString().toLowerCase() ?? '';
    final label = item['label']?.toString().toLowerCase() ?? '';
    final icon = item['icon']?.toString().toLowerCase() ?? '';

    return id == 'security_deposit' ||
        label.contains('security deposit') ||
        icon == 'security';
  }

  /// Extracts a per-day price from text like `£10.02 / day`.
  double _extractPricePerDay(dynamic value) {
    if (value == null) return 0;

    final text = value.toString().trim().toLowerCase();

    if (text.isEmpty || text == 'free' || text.contains('included')) {
      return 0;
    }

    if (!text.contains('£') &&
        !text.contains(r'$') &&
        !text.contains('€') &&
        !text.contains('+')) {
      return 0;
    }

    final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(text);

    if (match == null) return 0;

    return double.tryParse(match.group(1) ?? '') ?? 0;
  }

  /// Extracts money from numbers or strings.
  double _extractMoney(dynamic value) {
    if (value == null) return 0;

    final text = value.toString();
    final clean = text.replaceAll(RegExp(r'[^0-9.]'), '');

    return double.tryParse(clean) ?? 0;
  }

  /// Formats a display value while preserving existing currency symbols.
  String _formatDisplayValue(dynamic value, String currency) {
    if (value == null) return '';

    if (value is num) {
      return _formatMoney(value.toDouble(), currency);
    }

    final text = value.toString().trim();

    if (text.isEmpty) return '';

    final hasCurrencySymbol = RegExp(r'[£$€¥₹]').hasMatch(text);

    if (hasCurrencySymbol) {
      return text;
    }

    final parsed = double.tryParse(text);

    if (parsed != null) {
      return _formatMoney(parsed, currency);
    }

    return text;
  }

  /// Formats a numeric value into the selected currency.
  String _formatMoney(
    double value,
    String currency, {
    bool forceDecimals = false,
  }) {
    final symbol = currencySymbol(currency);

    final amount = forceDecimals || value % 1 != 0
        ? value.toStringAsFixed(2)
        : value.toStringAsFixed(0);

    return '$symbol$amount';
  }
}

/// Shared outer shell for the price breakdown card.
///
/// Keeps root margin handling consistent for:
/// - config.layout rendering
/// - legacy fallback rendering
class _PriceBreakdownShell extends StatelessWidget {
  final List<String> classes;
  final Widget child;

  const _PriceBreakdownShell({required this.classes, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: ElementSettings.margin(classes),
      child: child,
    );
  }
}

/// Layout-driven renderer.
///
/// This lets JSON control the visible UI using:
/// - column
/// - row
/// - container
/// - text
/// - icon
/// - for_each
///
/// The computed data passed here already includes:
/// - recalculated rows
/// - final total
/// - BNPL note
class _PriceBreakdownLayoutRenderer extends StatelessWidget {
  final Map<dynamic, dynamic> data;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;

  const _PriceBreakdownLayoutRenderer({
    required this.data,
    required this.theme,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: layout.map((section) {
        return JsonLayoutRenderer(
          node: section,

          // Main computed data for JSON keys.
          // Example:
          // "key": "title"
          // "itemsKey": "items"
          // "key": "total.value"
          data: data,

          // Optional local alias for nested usage.
          locals: {"priceBreakdown": data},

          theme: theme,
          config: config,
          currency: data['currency']?.toString() ?? '',
        );
      }).toList(),
    );
  }
}

/// Legacy fallback renderer.
///
/// Used when `config.layout` is not provided.
/// This keeps all existing screens working safely.
class _PriceBreakdownLegacy extends StatelessWidget {
  final Map<dynamic, dynamic> data;
  final Map<dynamic, dynamic> theme;

  const _PriceBreakdownLegacy({required this.data, required this.theme});

  @override
  Widget build(BuildContext context) {
    final items = List<Map<dynamic, dynamic>>.from(data['items'] ?? []);
    final total = Map<dynamic, dynamic>.from(data['total'] ?? {});
    final note = data['note']?.toString();

    final cardClasses = ElementSettings.classList(theme['card']);

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

        Container(
          width: double.infinity,
          padding: ElementSettings.padding(cardClasses),
          decoration: ElementSettings.decoration(context, cardClasses),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _BreakdownRow(item: item, theme: theme),
                );
              }),

              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: ElementSettings.background(
                  context,
                  ElementSettings.classList(theme['divider']),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      total['label']?.toString() ?? 'Total',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['totalLabel']),
                      ),
                    ),
                  ),

                  Text(
                    total['value']?.toString() ?? '',
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['totalValue']),
                    ),
                  ),
                ],
              ),

              if ((note ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  note!,
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(theme['note']),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// One row inside the legacy price breakdown.
///
/// Supports:
/// - optional selectable radio placeholder
/// - optional icon
/// - per-row label classes
/// - per-row value classes
class _BreakdownRow extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final Map<dynamic, dynamic> theme;

  /// Creates a breakdown row.
  const _BreakdownRow({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    final selectable = item['selectable'] == true;

    final labelClasses = ElementSettings.classList(
      item['labelClasses'] ?? theme['label'],
    );

    final valueClasses = ElementSettings.classList(
      item['valueClasses'] ?? theme['value'],
    );

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              if (selectable) ...[
                Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ElementSettings.borderColor(context, [
                        'border-muted',
                      ]),
                    ),
                  ),
                ),
              ],

              if (item['icon'] != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ElementIcons.show(
                    context,
                    item['icon'],
                    size: 12,
                    color: ElementSettings.textColor(context, labelClasses),
                  ),
                ),

              Expanded(
                child: Text(
                  item['label']?.toString() ?? '',
                  style: ElementSettings.textStyle(context, labelClasses),
                ),
              ),
            ],
          ),
        ),

        Text(
          item['value']?.toString() ?? '',
          style: ElementSettings.textStyle(context, valueClasses),
        ),
      ],
    );
  }
}
