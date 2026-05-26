import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class VehicleFilterState {
  final String accountType;
  final String pickupLocation;
  final String pickupDateTime;
  final String returnDateTime;
  final String vehicleCategory;
  final String transmission;
  final String seats;
  final double budgetMin;
  final double budgetMax;
  final String collectionDropoffLocation;

  const VehicleFilterState({
    this.accountType = 'personal',
    this.pickupLocation = '',
    this.collectionDropoffLocation = '',
    this.pickupDateTime = '',
    this.returnDateTime = '',
    this.vehicleCategory = 'all',
    this.transmission = 'all',
    this.seats = 'all',
    this.budgetMin = 0,
    this.budgetMax = 500,
  });

  VehicleFilterState copyWith({
    String? accountType,
    String? pickupLocation,
    String? collectionDropoffLocation,
    String? pickupDateTime,
    String? returnDateTime,
    String? vehicleCategory,
    String? transmission,
    String? seats,
    double? budgetMin,
    double? budgetMax,
  }) {
    return VehicleFilterState(
      accountType: accountType ?? this.accountType,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      collectionDropoffLocation:
          collectionDropoffLocation ?? this.collectionDropoffLocation,
      pickupDateTime: pickupDateTime ?? this.pickupDateTime,
      returnDateTime: returnDateTime ?? this.returnDateTime,
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      transmission: transmission ?? this.transmission,
      seats: seats ?? this.seats,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
    );
  }
}

class VehicleFilterNotifier extends StateNotifier<VehicleFilterState> {
  VehicleFilterNotifier() : super(const VehicleFilterState());

  void setAccountType(String value) {
    state = state.copyWith(accountType: value);
  }

  void setCollectionDropoffLocation(String value) {
    state = state.copyWith(collectionDropoffLocation: value);
  }

  void setPickupLocation(String value) {
    state = state.copyWith(pickupLocation: value);
  }

  void setPickupDateTime(String value) {
    state = state.copyWith(pickupDateTime: value);
  }

  void setReturnDateTime(String value) {
    state = state.copyWith(returnDateTime: value);
  }

  void setVehicleCategory(String value) {
    state = state.copyWith(vehicleCategory: value);
  }

  void setTransmission(String value) {
    state = state.copyWith(transmission: value);
  }

  void setSeats(String value) {
    state = state.copyWith(seats: value);
  }

  void setBudget(double min, double max) {
    state = state.copyWith(budgetMin: min, budgetMax: max);
  }

  void reset() {
    state = const VehicleFilterState();
  }
}

final vehicleFilterProvider =
    StateNotifierProvider<VehicleFilterNotifier, VehicleFilterState>(
      (ref) => VehicleFilterNotifier(),
    );

final vehicleFilterCatalogProvider = StateProvider<List<Map<dynamic, dynamic>>>(
  (ref) => [],
);

final vehicleMatchedCountProvider = Provider<int>((ref) {
  final filter = ref.watch(vehicleFilterProvider);
  final items = ref.watch(vehicleFilterCatalogProvider);

  return filterVehicleItems(items, filter).length;
});

List<Map<dynamic, dynamic>> filterVehicleItems(
  List<Map<dynamic, dynamic>> items,
  VehicleFilterState filter,
) {
  return items.where((item) {
    final category = item['category']?.toString() ?? '';
    final transmission = item['transmission']?.toString() ?? '';
    final seatCount = item['seatCount']?.toString() ?? '';
    final price = _readNum(item, 'price.dayRate.value');

    final matchesCategory =
        filter.vehicleCategory == 'all' || filter.vehicleCategory == category;

    final matchesTransmission =
        filter.transmission == 'all' || filter.transmission == transmission;

    final matchesSeats = filter.seats == 'all' || filter.seats == seatCount;

    final matchesBudget =
        price >= filter.budgetMin && price <= filter.budgetMax;

    return matchesCategory &&
        matchesTransmission &&
        matchesSeats &&
        matchesBudget;
  }).toList();
}

double _readNum(Map<dynamic, dynamic> source, String path) {
  dynamic current = source;

  for (final key in path.split('.')) {
    if (current is Map && current.containsKey(key)) {
      current = current[key];
    } else {
      return 0;
    }
  }

  if (current is num) return current.toDouble();
  if (current is String) return double.tryParse(current) ?? 0;

  return 0;
}
