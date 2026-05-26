class ListSorter {
  static List<Map<dynamic, dynamic>> sort(
    List<Map<dynamic, dynamic>> items,
    String selectedSort,
  ) {
    final sorted = List<Map<dynamic, dynamic>>.from(items);

    switch (selectedSort) {
      case 'Price: Low to High':
        sorted.sort((a, b) {
          final aPrice = numValue(a, 'price.dayRate.value');
          final bPrice = numValue(b, 'price.dayRate.value');
          return aPrice.compareTo(bPrice);
        });
        break;

      case 'Price: High to Low':
        sorted.sort((a, b) {
          final aPrice = numValue(a, 'price.dayRate.value');
          final bPrice = numValue(b, 'price.dayRate.value');
          return bPrice.compareTo(aPrice);
        });
        break;

      case 'Highest Rated':
        sorted.sort((a, b) {
          final aRating = numValue(a, 'rating.value');
          final bRating = numValue(b, 'rating.value');
          return bRating.compareTo(aRating);
        });
        break;

      case 'Relevance':
      default:
        break;
    }

    return sorted;
  }

  static num numValue(Map<dynamic, dynamic> item, String path) {
    dynamic current = item;

    for (final key in path.split('.')) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        return 0;
      }
    }

    if (current is num) return current;

    return num.tryParse(current.toString()) ?? 0;
  }
}
