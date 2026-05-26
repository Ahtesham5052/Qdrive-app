import 'package:flutter_riverpod/legacy.dart';

class CheckoutOptionSectionState {
  final String? selectedOptionId;
  final bool calculated;
  final double distanceMiles;
  final double fee;
  final String? selectedTimeId;

  const CheckoutOptionSectionState({
    this.selectedOptionId,
    this.calculated = false,
    this.distanceMiles = 0,
    this.fee = 0,
    this.selectedTimeId,
  });
}

class CheckoutOptionNotifier
    extends StateNotifier<Map<String, CheckoutOptionSectionState>> {
  CheckoutOptionNotifier() : super({});

  void selectOption({required String sectionId, required String optionId}) {
    state = {
      ...state,
      sectionId: CheckoutOptionSectionState(selectedOptionId: optionId),
    };
  }

  void calculateDistance({
    required String sectionId,
    required Map<dynamic, dynamic> option,
  }) {
    final optionId = option['id']?.toString() ?? '';
    final calculation = Map<dynamic, dynamic>.from(option['calculation'] ?? {});

    final baseFee = _toDouble(calculation['baseFee']);
    final distanceMiles = _toDouble(calculation['distanceMiles']);
    final pricePerMile = _toDouble(calculation['pricePerMile']);

    final fee = baseFee + (distanceMiles * pricePerMile);

    final slots = List<Map<dynamic, dynamic>>.from(
      calculation['timeSlots'] ?? [],
    );

    String? selectedTimeId;

    for (final slot in slots) {
      if (slot['selected'] == true) {
        selectedTimeId = slot['id']?.toString();
        break;
      }
    }

    selectedTimeId ??= slots.isNotEmpty ? slots.first['id']?.toString() : null;

    state = {
      ...state,
      sectionId: CheckoutOptionSectionState(
        selectedOptionId: optionId,
        calculated: true,
        distanceMiles: distanceMiles,
        fee: fee,
        selectedTimeId: selectedTimeId,
      ),
    };
  }

  void selectTime({required String sectionId, required String timeId}) {
    final current = state[sectionId];

    if (current == null) return;

    state = {
      ...state,
      sectionId: CheckoutOptionSectionState(
        selectedOptionId: current.selectedOptionId,
        calculated: current.calculated,
        distanceMiles: current.distanceMiles,
        fee: current.fee,
        selectedTimeId: timeId,
      ),
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}

final checkoutOptionProvider =
    StateNotifierProvider<
      CheckoutOptionNotifier,
      Map<String, CheckoutOptionSectionState>
    >((ref) => CheckoutOptionNotifier());
