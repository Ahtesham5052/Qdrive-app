String formatMoney(double value) {
  if (value % 1 == 0) return '£${value.toStringAsFixed(0)}';
  return '£${value.toStringAsFixed(2)}';
}