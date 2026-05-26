String currencySymbol(String currency) {
  switch (currency) {
    case 'GBP':
      return '£';
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';
    default:
      return '';
  }
}
