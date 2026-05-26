import 'package:flutter_riverpod/legacy.dart';

/// Holds the current 360° virtual tour UI state.
class VirtualTourState {
  /// Exterior or Interior.
  final String mode;

  /// Current selected view.
  /// Exterior: Front, Right Side, Rear, Left Side
  /// Interior: Dashboard, Front Seats, Back Seats, Trunk
  final String view;

  /// Flat 2D rotation.
  /// 0 = Front
  /// 0.25 = Right Side
  /// 0.5 = Rear
  /// -0.25 = Left Side
  final double angle;

  /// Zoom scale for the viewer card.
  final double scale;

  const VirtualTourState({
    this.mode = 'Exterior',
    this.view = 'Front',
    this.angle = 0,
    this.scale = 1,
  });

  VirtualTourState copyWith({
    String? mode,
    String? view,
    double? angle,
    double? scale,
  }) {
    return VirtualTourState(
      mode: mode ?? this.mode,
      view: view ?? this.view,
      angle: angle ?? this.angle,
      scale: scale ?? this.scale,
    );
  }
}

class VirtualTourNotifier extends StateNotifier<VirtualTourState> {
  VirtualTourNotifier() : super(const VirtualTourState());

  /// Returns the correct bottom buttons depending on selected mode.
  List<String> get currentViews {
    return state.mode == 'Interior'
        ? const ['Dashboard', 'Front Seats', 'Back Seats', 'Trunk']
        : const ['Front', 'Right Side', 'Rear', 'Left Side'];
  }

  /// Maps a selected view to a flat card rotation.
  double _angleForView(String view) {
    switch (view) {
      case 'Right Side':
      case 'Front Seats':
        return 0.25;

      case 'Rear':
      case 'Back Seats':
        return 0.5;

      case 'Left Side':
      case 'Trunk':
        return -0.25;

      case 'Front':
      case 'Dashboard':
      default:
        return 0;
    }
  }

  /// Switch Exterior / Interior.
  /// Also resets view and zoom.
  void setMode(String mode) {
    final firstView = mode == 'Interior' ? 'Dashboard' : 'Front';

    state = VirtualTourState(mode: mode, view: firstView, angle: 0, scale: 1);
  }

  /// Select a direct view from bottom buttons.
  void setView(String view) {
    state = state.copyWith(view: view, angle: _angleForView(view));
  }

  /// Chevron left: move to previous named view.
  void rotateLeft() {
    final views = currentViews;
    final currentIndex = views.indexOf(state.view);
    final previousIndex = currentIndex <= 0
        ? views.length - 1
        : currentIndex - 1;

    setView(views[previousIndex]);
  }

  /// Chevron right: move to next named view.
  void rotateRight() {
    final views = currentViews;
    final currentIndex = views.indexOf(state.view);
    final nextIndex = currentIndex >= views.length - 1 ? 0 : currentIndex + 1;

    setView(views[nextIndex]);
  }

  /// Exterior direct actions.
  void frontView() => setView('Front');

  void rightSideView() => setView('Right Side');

  void rearView() => setView('Rear');

  void leftSideView() => setView('Left Side');

  /// Interior direct actions.
  void dashboardView() => setView('Dashboard');

  void frontSeatsView() => setView('Front Seats');

  void backSeatsView() => setView('Back Seats');

  void trunkView() => setView('Trunk');

  /// Zoom in, maximum 1.6.
  void zoomIn() {
    final next = state.scale + 0.1;

    state = state.copyWith(scale: next > 1.6 ? 1.6 : next);
  }

  /// Zoom out, minimum 0.7.
  void zoomOut() {
    final next = state.scale - 0.1;

    state = state.copyWith(scale: next < 0.7 ? 0.7 : next);
  }

  /// Reset current mode to its first view.
  void reset() {
    final firstView = state.mode == 'Interior' ? 'Dashboard' : 'Front';

    state = VirtualTourState(
      mode: state.mode,
      view: firstView,
      angle: 0,
      scale: 1,
    );
  }
}

final virtualTourProvider =
    StateNotifierProvider<VirtualTourNotifier, VirtualTourState>((ref) {
      return VirtualTourNotifier();
    });
