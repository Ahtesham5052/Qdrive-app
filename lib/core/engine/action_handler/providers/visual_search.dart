import 'package:flutter_riverpod/legacy.dart';

class VisualSearchMediaState {
  final String? fileName;
  final String? filePath;
  final String? mediaType;
  final bool fromCamera;

  const VisualSearchMediaState({
    this.fileName,
    this.filePath,
    this.mediaType,
    this.fromCamera = false,
  });

  const VisualSearchMediaState.empty()
      : fileName = null,
        filePath = null,
        mediaType = null,
        fromCamera = false;

  bool get hasMedia => fileName != null && fileName!.isNotEmpty;
}

final visualSearchMediaProvider =
    StateProvider<VisualSearchMediaState>((ref) {
  return const VisualSearchMediaState.empty();
});