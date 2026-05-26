import 'package:flutter_riverpod/legacy.dart';

class CheckoutExtraItem {
  final String id;
  final String title;
  final String price;
  final int quantity;

  const CheckoutExtraItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });

  CheckoutExtraItem copyWith({
    String? id,
    String? title,
    String? price,
    int? quantity,
  }) {
    return CheckoutExtraItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CheckoutExtrasNotifier
    extends StateNotifier<Map<String, CheckoutExtraItem>> {
  CheckoutExtrasNotifier() : super({});

  void increase(Map<dynamic, dynamic> item) {
    final id = item['id']?.toString() ?? '';

    if (id.isEmpty) return;

    final current = state[id];

    if (current == null) {
      state = {
        ...state,
        id: CheckoutExtraItem(
          id: id,
          title: item['title']?.toString() ?? '',
          price: item['price']?.toString() ?? '',
          quantity: 1,
        ),
      };
      return;
    }

    state = {...state, id: current.copyWith(quantity: current.quantity + 1)};
  }

  void decrease(String id) {
    final current = state[id];

    if (current == null) return;

    final newQuantity = current.quantity - 1;

    if (newQuantity <= 0) {
      final updated = {...state};
      updated.remove(id);
      state = updated;
      return;
    }

    state = {...state, id: current.copyWith(quantity: newQuantity)};
  }

  void clear() {
    state = {};
  }
}

final checkoutExtrasProvider =
    StateNotifierProvider<
      CheckoutExtrasNotifier,
      Map<String, CheckoutExtraItem>
    >((ref) => CheckoutExtrasNotifier());
