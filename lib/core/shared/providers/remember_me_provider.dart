import 'package:flutter_riverpod/legacy.dart';

final jsonCheckboxProvider =
    StateProvider<Map<String, bool>>((ref) => <String, bool>{});