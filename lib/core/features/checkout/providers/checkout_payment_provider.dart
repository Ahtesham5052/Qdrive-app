import 'package:flutter_riverpod/legacy.dart';

/// Stores selected payment method by section id.
///
/// Example:
/// {
///   "payment_method": "installments"
/// }
final selectedPaymentMethodProvider = StateProvider<Map<String, String>>(
  (ref) => {},
);

/// Stores selected Buy Now Pay Later provider by payment section id.
///
/// Example:
/// {
///   "payment_method": "clearpay"
/// }
final selectedBnplProvider = StateProvider<Map<String, String>>((ref) => {});
