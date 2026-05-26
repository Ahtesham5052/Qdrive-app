import 'package:Qdrive/core/features/checkout/providers/checkout_extras_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_mileage_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_option_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_protection_provider.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_qdrive_pass_provider.dart';
import 'package:Qdrive/core/shared/providers/flight_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutPriceDetailsSheet extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const CheckoutPriceDetailsSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = data['title']?.toString() ?? 'Price details';
    final subtitle =
        data['subtitle']?.toString() ??
        'Summary by step and line-item amounts. Total includes tax.';

    final baseSummary = _mapList(data['summary']);
    final baseAmounts = _mapList(data['amounts']);

    final optionStates = ref.watch(checkoutOptionProvider);
    final selectedProtection = ref.watch(selectedProtectionOptionProvider);
    final selectedExtras = ref.watch(checkoutExtrasProvider);
    final selectedQdrivePass = ref.watch(selectedQdrivePassPlanOptionProvider);
    final selectedMileage = ref.watch(selectedMileageOptionProvider);
    final flightDetails = ref.watch(checkoutFormProvider);

    final rentalDays = _rentalDays(
      data: data,
      baseSummary: baseSummary,
      baseAmounts: baseAmounts,
    );

    final summary = _buildSummary(
      baseSummary: baseSummary,
      optionStates: optionStates,
      selectedProtection: selectedProtection,
      selectedExtras: selectedExtras,
      selectedQdrivePass: selectedQdrivePass,
      selectedMileage: selectedMileage,
      flightDetails: flightDetails,
    );

    final amounts = _buildAmounts(
      baseAmounts: baseAmounts,
      optionStates: optionStates,
      selectedProtection: selectedProtection,
      selectedExtras: selectedExtras,
      selectedQdrivePass: selectedQdrivePass,
      selectedMileage: selectedMileage,
      rentalDays: rentalDays,
    );

    final total = amounts.fold<double>(
      0,
      (sum, item) => sum + _numValue(item['value']),
    );

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.92,
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF050505),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (subtitle.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  subtitle,
                                  style: const TextStyle(
                                    color: Color(0xFFC9C9C9),
                                    fontSize: 12,
                                    height: 1.35,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => Navigator.of(context).maybePop(),
                          child: const SizedBox(
                            width: 34,
                            height: 34,
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFF242424)),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...summary.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _SummaryCard(item: item),
                            );
                          }),
                          const SizedBox(height: 14),
                          Text(
                            data['amountsTitle']?.toString() ?? 'Amounts',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF171717),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                ...amounts.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _AmountRow(item: item),
                                  );
                                }),
                                const Divider(
                                  height: 20,
                                  color: Color(0xFF333333),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data['totalLabel']?.toString() ??
                                            'Total',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _money(total),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static List<Map<dynamic, dynamic>> _buildSummary({
    required List<Map<dynamic, dynamic>> baseSummary,
    required dynamic optionStates,
    required dynamic selectedProtection,
    required dynamic selectedExtras,
    required dynamic selectedQdrivePass,
    required dynamic selectedMileage,
    required dynamic flightDetails,
  }) {
    final summary = [...baseSummary];

    final deliveryState = _readMapItem(optionStates, 'delivery_preference');
    final collectionState = _readMapItem(optionStates, 'collection_preference');

    final pickupText = _optionSummary(
      deliveryState,
      fallback: _summaryValue(summary, 'Pickup / Drop-off').split('\n').first,
    );

    final collectionText = _optionSummary(
      collectionState,
      fallback: _summaryValue(
        summary,
        'Pickup / Drop-off',
      ).split('\n').skip(1).join('\n'),
    );

    if (pickupText.isNotEmpty || collectionText.isNotEmpty) {
      _replaceSummaryValue(
        summary,
        title: 'Pickup / Drop-off',
        value: [
          if (pickupText.isNotEmpty) pickupText,
          if (collectionText.isNotEmpty) collectionText,
        ].join('\n'),
      );
    }

    final mileageTitle = _readDynamic(selectedMileage, 'title');
    if (mileageTitle.isNotEmpty) {
      _replaceSummaryValue(summary, title: 'Mileage', value: mileageTitle);
    }

    final protectionTitle = _readDynamic(selectedProtection, 'title');
    if (protectionTitle.isNotEmpty) {
      _replaceSummaryValue(
        summary,
        title: 'Protection package',
        value: protectionTitle,
      );
    }

    final extrasText = _extrasText(selectedExtras);
    _replaceSummaryValue(
      summary,
      title: 'Extras',
      value: extrasText.isEmpty ? 'No extras selected' : extrasText,
    );

    final qdrivePassTitle = _readDynamic(selectedQdrivePass, 'title');
    if (qdrivePassTitle.isNotEmpty) {
      _replaceSummaryValue(
        summary,
        title: 'Qdrive Pass',
        value: qdrivePassTitle,
      );
    }

    final departureDate = _readMapValue(flightDetails, 'departureDate');
    final flightNumber = _readMapValue(flightDetails, 'flightNumber');

    final hasFlightDetails =
        departureDate.trim().isNotEmpty || flightNumber.trim().isNotEmpty;

    final existingFlightIndex = summary.indexWhere(
      (item) => item['title']?.toString().toLowerCase() == 'flight details',
    );

    if (hasFlightDetails) {
      final flightItem = {
        'title': 'Flight details',
        'value': [
          if (departureDate.trim().isNotEmpty) 'Departure: $departureDate',
          if (flightNumber.trim().isNotEmpty) 'Flight: $flightNumber',
        ].join('\n'),
      };

      if (existingFlightIndex == -1) {
        summary.add(flightItem);
      } else {
        summary[existingFlightIndex] = flightItem;
      }
    } else if (existingFlightIndex != -1) {
      summary.removeAt(existingFlightIndex);
    }

    return summary;
  }

  static List<Map<dynamic, dynamic>> _buildAmounts({
    required List<Map<dynamic, dynamic>> baseAmounts,
    required dynamic optionStates,
    required dynamic selectedProtection,
    required dynamic selectedExtras,
    required dynamic selectedQdrivePass,
    required dynamic selectedMileage,
    required int rentalDays,
  }) {
    final rows = <Map<dynamic, dynamic>>[];

    final baseRental = _baseAmount(baseAmounts, 'base rental');

    rows.add({
      'label': _baseLabel(baseAmounts, 'base rental', 'Base rental'),
      'value': baseRental,
    });

    final extrasTotal = _extrasTotal(selectedExtras, rentalDays);

    rows.add({'label': 'Extras', 'value': extrasTotal});

    final deliveryState = _readMapItem(optionStates, 'delivery_preference');
    final collectionState = _readMapItem(optionStates, 'collection_preference');

    rows.add({'label': 'Delivery fee', 'value': _optionFee(deliveryState)});

    rows.add({'label': 'Collection fee', 'value': _optionFee(collectionState)});

    final mileagePrice = _extractPricePerDay(
      _readDynamic(selectedMileage, 'price'),
    );

    rows.add({
      'label': mileagePrice > 0
          ? '${_readDynamic(selectedMileage, 'title')} ($rentalDays days)'
          : 'Mileage',
      'value': mileagePrice * rentalDays,
    });

    final protectionPrice = _extractPricePerDay(
      _readDynamic(selectedProtection, 'price'),
    );

    if (protectionPrice > 0) {
      rows.add({
        'label':
            '${_readDynamic(selectedProtection, 'title')} ($rentalDays days)',
        'value': protectionPrice * rentalDays,
        'highlight': true,
      });
    }

    final subtotalBeforeTax = rows.fold<double>(
      0,
      (sum, item) => sum + _numValue(item['value']),
    );

    final taxRate = _taxRate(baseAmounts);

    if (taxRate > 0) {
      rows.add({
        'label': 'Tax (${(taxRate * 100).toStringAsFixed(0)}%)',
        'value': subtotalBeforeTax * taxRate,
      });
    }

    final qdrivePassPrice = _extractMoney(
      _readDynamic(selectedQdrivePass, 'price'),
    );

    if (qdrivePassPrice > 0) {
      rows.add({
        'label': _readDynamic(selectedQdrivePass, 'title').isEmpty
            ? 'QDrive Pass'
            : _readDynamic(selectedQdrivePass, 'title'),
        'value': qdrivePassPrice,
        'highlight': true,
      });
    }

    return rows;
  }

  static int _rentalDays({
    required Map<dynamic, dynamic> data,
    required List<Map<dynamic, dynamic>> baseSummary,
    required List<Map<dynamic, dynamic>> baseAmounts,
  }) {
    final direct = _intValue(data['rentalDays'], 0);
    if (direct > 0) return direct;

    final dates = _summaryValue(baseSummary, 'Dates');
    final dateMatch = RegExp(r'(\d+)\s*days?').firstMatch(dates);

    if (dateMatch != null) {
      return int.tryParse(dateMatch.group(1) ?? '') ?? 1;
    }

    final baseLabel = _baseLabel(baseAmounts, 'base rental', '');
    final labelMatch = RegExp(r'\((\d+)\s*days?\)').firstMatch(baseLabel);

    if (labelMatch != null) {
      return int.tryParse(labelMatch.group(1) ?? '') ?? 1;
    }

    return 1;
  }

  static String _optionSummary(dynamic state, {required String fallback}) {
    final selectedOption =
        _readRaw(state, 'selectedOption') ??
        _readRaw(state, 'option') ??
        _readRaw(state, 'selected');

    final title = _readDynamic(selectedOption, 'title');
    final description = _readDynamic(selectedOption, 'description');

    if (title.isNotEmpty && description.isNotEmpty) {
      return '$title\n$description';
    }

    if (title.isNotEmpty) return title;

    final stateTitle = _readDynamic(state, 'title');
    if (stateTitle.isNotEmpty) return stateTitle;

    return fallback.trim();
  }

  static double _optionFee(dynamic state) {
    if (state == null) return 0;

    final calculated = _readBool(state, 'calculated');

    if (calculated) {
      return _extractMoney(_readRaw(state, 'fee'));
    }

    final selectedOption =
        _readRaw(state, 'selectedOption') ??
        _readRaw(state, 'option') ??
        _readRaw(state, 'selected');

    final optionPrice = _readDynamic(selectedOption, 'price');

    if (optionPrice.isNotEmpty) {
      return _extractMoney(optionPrice);
    }

    return _extractMoney(_readDynamic(state, 'price'));
  }

  static double _extrasTotal(dynamic selectedExtras, int rentalDays) {
    if (selectedExtras == null) return 0;

    double total = 0;

    if (selectedExtras is Map) {
      for (final extra in selectedExtras.values) {
        final quantity = _readDynamicInt(extra, 'quantity');

        if (quantity <= 0) continue;

        final price = _extractPricePerDay(_readDynamic(extra, 'price'));

        total += price * rentalDays * quantity;
      }
    }

    return total;
  }

  static String _extrasText(dynamic selectedExtras) {
    if (selectedExtras == null) return '';

    final parts = <String>[];

    if (selectedExtras is Map) {
      for (final extra in selectedExtras.values) {
        final quantity = _readDynamicInt(extra, 'quantity');

        if (quantity <= 0) continue;

        final title = _readDynamic(extra, 'title');

        if (title.isNotEmpty) {
          parts.add('$title ×$quantity');
        }
      }
    }

    return parts.join(' · ');
  }

  static double _baseAmount(
    List<Map<dynamic, dynamic>> amounts,
    String contains,
  ) {
    final row = amounts.firstWhere(
      (item) =>
          item['label']?.toString().toLowerCase().contains(contains) == true,
      orElse: () => {},
    );

    return _numValue(row['value']);
  }

  static String _baseLabel(
    List<Map<dynamic, dynamic>> amounts,
    String contains,
    String fallback,
  ) {
    final row = amounts.firstWhere(
      (item) =>
          item['label']?.toString().toLowerCase().contains(contains) == true,
      orElse: () => {},
    );

    return row['label']?.toString() ?? fallback;
  }

  static double _taxRate(List<Map<dynamic, dynamic>> amounts) {
    final taxRow = amounts.firstWhere(
      (item) => item['label']?.toString().toLowerCase().contains('tax') == true,
      orElse: () => {},
    );

    final label = taxRow['label']?.toString() ?? '';
    final match = RegExp(r'(\d+(\.\d+)?)\s*%').firstMatch(label);

    if (match == null) return 0;

    final percent = double.tryParse(match.group(1) ?? '') ?? 0;

    return percent / 100;
  }

  static void _replaceSummaryValue(
    List<Map<dynamic, dynamic>> summary, {
    required String title,
    required String value,
  }) {
    final index = summary.indexWhere(
      (item) => item['title']?.toString().toLowerCase() == title.toLowerCase(),
    );

    if (index == -1) {
      summary.add({'title': title, 'value': value});
      return;
    }

    summary[index] = {...summary[index], 'value': value};
  }

  static String _summaryValue(
    List<Map<dynamic, dynamic>> summary,
    String title,
  ) {
    final item = summary.firstWhere(
      (item) => item['title']?.toString().toLowerCase() == title.toLowerCase(),
      orElse: () => {},
    );

    return item['value']?.toString() ?? '';
  }

  static List<Map<dynamic, dynamic>> _mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();
  }

  static dynamic _readMapItem(dynamic source, String key) {
    if (source is Map) return source[key];
    return null;
  }

  static String _readMapValue(dynamic source, String key) {
    if (source is Map && source[key] != null) {
      return source[key].toString();
    }

    return '';
  }

  static dynamic _readRaw(dynamic source, String key) {
    if (source == null) return null;

    if (source is Map) return source[key];

    try {
      return switch (key) {
        'title' => source.title,
        'description' => source.description,
        'price' => source.price,
        'quantity' => source.quantity,
        'fee' => source.fee,
        'calculated' => source.calculated,
        'selectedOption' => source.selectedOption,
        'option' => source.option,
        'selected' => source.selected,
        _ => null,
      };
    } catch (_) {
      return null;
    }
  }

  static String _readDynamic(dynamic source, String key) {
    final value = _readRaw(source, key);
    return value?.toString() ?? '';
  }

  static int _readDynamicInt(dynamic source, String key) {
    final value = _readDynamic(source, key);
    return int.tryParse(value) ?? 0;
  }

  static bool _readBool(dynamic source, String key) {
    final value = _readRaw(source, key);

    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';

    return false;
  }

  static int _intValue(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static double _numValue(dynamic value) {
    if (value is num) return value.toDouble();

    if (value is String) {
      return _extractMoney(value);
    }

    return 0;
  }

  static double _extractMoney(dynamic value) {
    if (value == null) return 0;

    final text = value.toString().trim().toLowerCase();

    if (text.isEmpty || text == 'free' || text.contains('included')) {
      return 0;
    }

    final clean = text.replaceAll(RegExp(r'[^0-9.]'), '');

    return double.tryParse(clean) ?? 0;
  }

  static double _extractPricePerDay(dynamic value) {
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

  static String _money(double value) {
    return '£${value.toStringAsFixed(2)}';
  }
}

class _SummaryCard extends StatelessWidget {
  final Map<dynamic, dynamic> item;

  const _SummaryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final title = item['title']?.toString() ?? '';
    final value = item['value']?.toString() ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFF303030)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFCFCFCF),
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final Map<dynamic, dynamic> item;

  const _AmountRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final label = item['label']?.toString() ?? '';
    final value = CheckoutPriceDetailsSheet._numValue(item['value']);
    final highlight = item['highlight'] == true;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: highlight ? const Color(0xFF60A5FA) : Colors.white,
              fontSize: 12,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          CheckoutPriceDetailsSheet._money(value),
          style: TextStyle(
            color: highlight ? const Color(0xFF60A5FA) : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
