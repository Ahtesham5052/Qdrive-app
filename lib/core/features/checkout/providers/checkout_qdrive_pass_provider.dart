import 'package:flutter_riverpod/legacy.dart';

final selectedQdrivePassPlanProvider = StateProvider<String?>((ref) => null);

final selectedQdrivePassPlanOptionProvider =
    StateProvider<Map<dynamic, dynamic>?>((ref) => null);

final expandedQdrivePassCoverageProvider = StateProvider<String?>(
  (ref) => null,
);
