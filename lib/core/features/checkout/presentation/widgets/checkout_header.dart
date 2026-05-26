import 'package:Qdrive/core/features/checkout/providers/checkout_mileage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';

import 'package:Qdrive/core/features/checkout/providers/checkout_extras_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_option_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_protection_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_qdrive_pass_provider.dart';
import 'package:Qdrive/core/utils/currency.dart';

class CheckoutHeader extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const CheckoutHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final classes = ElementSettings.classList(data['classes']);

    final title = props['title']?.toString() ?? '';
    final label = props['label']?.toString() ?? '';
    final stepText = props['stepText']?.toString() ?? '';

    final currentStep = _intValue(props['currentStep'], 1);
    final totalSteps = _intValue(props['totalSteps'], 1);

    final showBack = props['showBack'] == true;
    final backIcon = props['backIcon']?.toString() ?? 'arrow_back';

    final priceDetailsLabel =
        props['priceDetailsLabel']?.toString() ?? 'Price details';

    final backAction = props['backAction'];
    final priceAction = props['priceAction'];

    final totalPrice = _dynamicTotalText(ref, props);

    final progressTrackClasses = ElementSettings.classList(
      theme['progressTrack'],
    );

    final progressActiveClasses = ElementSettings.classList(
      theme['progressActive'],
    );

    final hasPriceDetails = totalPrice.trim().isNotEmpty;

    return Container(
      margin: ElementSettings.margin(classes),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBack) ...[
                GestureDetector(
                  onTap: () {
                    if (backAction is Map) {
                      ActionHandler.handle(
                        context,
                        Map<dynamic, dynamic>.from(backAction),
                      );
                    } else {
                      Navigator.maybePop(context);
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: ElementSettings.decoration(
                      context,
                      ElementSettings.classList(theme['backButton']),
                    ),
                    child: Icon(
                      ElementIcons.get(backIcon),
                      size: 20,
                      color: ElementSettings.textColor(
                        context,
                        ElementSettings.classList(theme['backIcon']),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: showBack ? 9 : 0),
                  child: Text(
                    title,
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['title']),
                    ),
                  ),
                ),
              ),

              if (hasPriceDetails)
                _PriceDetailsButton(
                  totalPrice: totalPrice,
                  priceDetailsLabel: priceDetailsLabel,
                  priceAction: priceAction,
                  theme: theme,
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: ElementSettings.decoration(
                    context,
                    ElementSettings.classList(theme['counter']),
                  ),
                  child: Text(
                    '$currentStep/$totalSteps',
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['counterText']),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            label,
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['stepLabel']),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            stepText,
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['stepText']),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final isActive = stepNumber <= currentStep;

              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index == totalSteps - 1 ? 0 : 3,
                  ),
                  decoration: BoxDecoration(
                    color: ElementSettings.background(
                      context,
                      isActive ? progressActiveClasses : progressTrackClasses,
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  static String _dynamicTotalText(WidgetRef ref, Map<dynamic, dynamic> props) {
    final currency = props['currency']?.toString() ?? 'GBP';
    final rentalDays = _rentalDays(props);

    final baseTotal = _extractMoney(props['totalPrice']);

    final selectedProtection = ref.watch(selectedProtectionOptionProvider);
    final selectedExtras = ref.watch(checkoutExtrasProvider);
    final selectedQdrivePass = ref.watch(selectedQdrivePassPlanOptionProvider);
    final optionStates = ref.watch(checkoutOptionProvider);

    double total = baseTotal;

    final protectionPrice = _extractPricePerDay(
      _readDynamic(selectedProtection, 'price'),
    );

    final selectedMileage = ref.watch(selectedMileageOptionProvider);

    final mileagePrice = _extractPricePerDay(
      _readDynamic(selectedMileage, 'price'),
    );

    if (mileagePrice > 0) {
      total += mileagePrice * rentalDays;
    }

    if (protectionPrice > 0) {
      total += protectionPrice * rentalDays;
    }

    if (selectedExtras is Map) {
      for (final extra in selectedExtras.values) {
        final quantity = _readDynamicInt(extra, 'quantity');

        if (quantity <= 0) continue;

        final price = _extractPricePerDay(_readDynamic(extra, 'price'));

        if (price > 0) {
          total += price * rentalDays * quantity;
        }
      }
    }

    final qdrivePassPrice = _extractMoney(
      _readDynamic(selectedQdrivePass, 'price'),
    );

    if (qdrivePassPrice > 0) {
      total += qdrivePassPrice;
    }

    final deliveryState = optionStates['delivery_preference'];
    final collectionState = optionStates['collection_preference'];

    final deliveryCalculated = _readDynamicBool(deliveryState, 'calculated');
    final collectionCalculated = _readDynamicBool(
      collectionState,
      'calculated',
    );

    if (deliveryCalculated) {
      total += _readDynamicDouble(deliveryState, 'fee');
    }

    if (collectionCalculated) {
      total += _readDynamicDouble(collectionState, 'fee');
    }

    return _formatMoney(total, currency);
  }

  static int _rentalDays(Map<dynamic, dynamic> props) {
    final direct = _intValue(props['rentalDays'], 0);

    if (direct > 0) return direct;

    final rentalPeriod = props['rentalPeriod'];

    if (rentalPeriod is Map) {
      final duration = rentalPeriod['duration']?.toString() ?? '';
      final match = RegExp(r'(\d+)').firstMatch(duration);

      if (match != null) {
        return int.tryParse(match.group(1) ?? '') ?? 1;
      }
    }

    return 1;
  }

  static int _intValue(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static String _readDynamic(dynamic source, String key) {
    if (source == null) return '';

    if (source is Map && source[key] != null) {
      return source[key].toString();
    }

    try {
      final value = switch (key) {
        'title' => source.title,
        'price' => source.price,
        'quantity' => source.quantity,
        _ => null,
      };

      return value?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  static int _readDynamicInt(dynamic source, String key) {
    final value = _readDynamic(source, key);
    return int.tryParse(value) ?? 0;
  }

  static bool _readDynamicBool(dynamic source, String key) {
    if (source == null) return false;

    if (source is Map && source[key] != null) {
      return source[key] == true;
    }

    try {
      final value = switch (key) {
        'calculated' => source.calculated,
        _ => null,
      };

      return value == true;
    } catch (_) {
      return false;
    }
  }

  static double _readDynamicDouble(dynamic source, String key) {
    if (source == null) return 0;

    if (source is Map && source[key] != null) {
      return _extractMoney(source[key]);
    }

    try {
      final value = switch (key) {
        'fee' => source.fee,
        _ => null,
      };

      return _extractMoney(value);
    } catch (_) {
      return 0;
    }
  }

  static double _extractMoney(dynamic value) {
    if (value == null) return 0;

    final clean = value.toString().replaceAll(RegExp(r'[^0-9.]'), '');

    return double.tryParse(clean) ?? 0;
  }

  static double _extractPricePerDay(dynamic value) {
    if (value == null) return 0;

    final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(value.toString());

    if (match == null) return 0;

    return double.tryParse(match.group(1) ?? '') ?? 0;
  }

  static String _formatMoney(double value, String currency) {
    final symbol = currencySymbol(currency);
    return '$symbol${value.toStringAsFixed(2)}';
  }
}

class _PriceDetailsButton extends StatelessWidget {
  final String totalPrice;
  final String priceDetailsLabel;
  final dynamic priceAction;
  final Map<dynamic, dynamic> theme;

  const _PriceDetailsButton({
    required this.totalPrice,
    required this.priceDetailsLabel,
    required this.priceAction,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final totalClasses = ElementSettings.classList(theme['priceTotal']);
    final detailsClasses = ElementSettings.classList(theme['priceDetails']);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (priceAction is Map) {
          ActionHandler.handle(
            context,
            Map<dynamic, dynamic>.from(priceAction),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Total: $totalPrice',
            style: ElementSettings.textStyle(
              context,
              totalClasses.isNotEmpty
                  ? totalClasses
                  : ['text-body', 'text-sm', 'font-bold'],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            priceDetailsLabel,
            style: ElementSettings.textStyle(
              context,
              detailsClasses.isNotEmpty
                  ? detailsClasses
                  : ['text-body', 'text-xs', 'font-bold'],
            ).copyWith(decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }
}
