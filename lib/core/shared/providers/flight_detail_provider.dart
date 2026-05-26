

import 'package:flutter_riverpod/legacy.dart';

final checkoutFormProvider =
    StateNotifierProvider<CheckoutFormNotifier, Map<String, String>>(
      (ref) => CheckoutFormNotifier(),
    );

class CheckoutFormNotifier extends StateNotifier<Map<String, String>> {
  CheckoutFormNotifier() : super({});

  void setValue(String key, String value) {
    state = {...state, key: value};
  }

  String value(String key, {String fallback = ''}) {
    return state[key] ?? fallback;
  }
}
