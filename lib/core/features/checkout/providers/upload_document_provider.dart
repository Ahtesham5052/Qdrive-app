import 'package:flutter_riverpod/legacy.dart';

/// Stores uploaded document paths by document type.
///
/// Example:
/// {
///   "driving_license": "/storage/file.jpg",
///   "identity_document": "/storage/file2.jpg"
/// }
final uploadedDocumentsProvider = StateProvider<Map<String, String>>(
  (ref) => {},
);

final validatingDocumentsProvider = StateProvider<Map<String, bool>>((ref) {
  return {};
});

final validatedDocumentsProvider = StateProvider<Map<String, bool>>((ref) {
  return {};
});
