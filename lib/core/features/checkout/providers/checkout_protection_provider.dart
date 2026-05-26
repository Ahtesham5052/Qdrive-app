import 'package:flutter_riverpod/legacy.dart';

final selectedProtectionProvider = StateProvider<String>(
  (ref) => 'no_extra_protection',
);

final expandedProtectionProvider = StateProvider<String?>((ref) => null);

final selectedProtectionOptionProvider = StateProvider<Map<dynamic, dynamic>?>(
  (ref) => null,
);
