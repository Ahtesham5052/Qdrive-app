import 'package:flutter_riverpod/legacy.dart';

class ReturnVehicleUiState {
  final bool photosUploaded;
  final bool inspectionComplete;
  final bool showReturnLaterBar;
  final int rating;
  final String reviewText;

  const ReturnVehicleUiState({
    this.photosUploaded = false,
    this.inspectionComplete = false,
    this.showReturnLaterBar = true,
    this.rating = 0,
    this.reviewText = '',
  });

  ReturnVehicleUiState copyWith({
    bool? photosUploaded,
    bool? inspectionComplete,
    bool? showReturnLaterBar,
    int? rating,
    String? reviewText,
  }) {
    return ReturnVehicleUiState(
      photosUploaded: photosUploaded ?? this.photosUploaded,
      inspectionComplete: inspectionComplete ?? this.inspectionComplete,
      showReturnLaterBar: showReturnLaterBar ?? this.showReturnLaterBar,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
    );
  }
}

final returnVehicleUiProvider = StateProvider<ReturnVehicleUiState>(
  (ref) => const ReturnVehicleUiState(),
);