import 'package:Qdrive/app/constants/app_constants.dart';
import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/engine/screen/screen_builder.dart';
import 'package:Qdrive/core/shared/widgets/search_widgets.dart';
import 'package:Qdrive/mock/vehicle_list_json.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';

final homeSearchOpenPanelProvider = StateProvider<String?>((ref) => null);

final homeSearchSelectedTabProvider = StateProvider<String>((ref) {
  return 'airport';
});

final homeSearchRoundTripProvider = StateProvider<bool>((ref) {
  return false;
});

final homeSearchReturnElsewhereProvider = StateProvider<bool>((ref) {
  return false;
});

final homeSearchSelectedLocationProvider = StateProvider<String?>((ref) {
  return null;
});

final homeSearchSelectedReturnLocationProvider = StateProvider<String?>((ref) {
  return null;
});
final homeSearchPickupDateProvider = StateProvider<String?>((ref) {
  return null;
});

final homeSearchReturnDateProvider = StateProvider<String?>((ref) {
  return null;
});

final homeSearchSelectedPickupDayProvider = StateProvider<int?>((ref) {
  return null;
});

final homeSearchSelectedReturnDayProvider = StateProvider<int?>((ref) {
  return null;
});

final homeSearchSelectedPickupTimeProvider = StateProvider<String?>((ref) {
  return null;
});

final homeSearchSelectedReturnTimeProvider = StateProvider<String?>((ref) {
  return null;
});

final homeSearchWithDriverProvider = StateProvider<bool>((ref) {
  return true;
});

class HomeSearchPanel extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const HomeSearchPanel({super.key, required this.data});

  static Map<dynamic, dynamic>? _resolveActionFromSection(
  Map<dynamic, dynamic> section,
) {
  final directAction = section['action'];

  if (directAction is Map) {
    return Map<dynamic, dynamic>.from(directAction);
  }

  final actionRef = section['actionRef']?.toString();

  if (actionRef != null && actionRef.isNotEmpty) {
    final actions = currentScreenJson['actions'];

    if (actions is Map && actions[actionRef] is Map) {
      return Map<dynamic, dynamic>.from(actions[actionRef]);
    }

    debugPrint('MORE FILTERS ACTION ERROR: actionRef not found: $actionRef');
  }

  return null;
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final classes = ElementSettings.classList(data['classes']);

    final departure = _map(props['departure']);
    final returnLocation = _map(props['returnLocation']);
    final pickup = _map(props['pickup']);
    final dropoff = _map(props['dropoff']);

    final openPanel = ref.watch(homeSearchOpenPanelProvider);
    final selectedTab = ref.watch(homeSearchSelectedTabProvider);
    final roundTrip = ref.watch(homeSearchRoundTripProvider);
    final returnElsewhere = ref.watch(homeSearchReturnElsewhereProvider);
    final selectedLocation = ref.watch(homeSearchSelectedLocationProvider);
    final selectedReturnLocation = ref.watch(
      homeSearchSelectedReturnLocationProvider,
    );

    final pickupDate = ref.watch(homeSearchPickupDateProvider);
    final returnDate = ref.watch(homeSearchReturnDateProvider);

    final withDriver = ref.watch(homeSearchWithDriverProvider);

    final moreFilters = _map(props['moreFilters']);

void handleMoreFiltersTap() {
  final action = _resolveActionFromSection(moreFilters);

  if (action == null) {
    debugPrint('MORE FILTERS ACTION ERROR: No action/actionRef found.');
    return;
  }

  ActionHandler.handle(context, action);
}

    final title = props['title']?.toString() ?? '';

    final displayLocation =
        selectedLocation ??
        departure['value']?.toString() ??
        departure['placeholder']?.toString() ??
        '';

    final displayReturnLocation =
        selectedReturnLocation ?? returnLocation['value']?.toString();

    return Container(
      margin: ElementSettings.margin(classes),
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 520;

          return Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              isCompact ? 18 : 26,
              isCompact ? 18 : 24,
              isCompact ? 18 : 26,
              isCompact ? 18 : 22,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title.isNotEmpty && !isCompact) ...[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF070707),
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 26),
                ],

                _TopLabelRow(
                  label: roundTrip
                      ? 'Departure and Return Location'
                      : departure['label']?.toString() ?? 'Departure',
                  value: roundTrip,
                  onChanged: (value) {
                    ref.read(homeSearchRoundTripProvider.notifier).state =
                        value;

                    // Keep Round-trip? and Add return location fully synced.
                    ref.read(homeSearchReturnElsewhereProvider.notifier).state =
                        value;
                  },
                ),

                const SizedBox(height: 10),

                QDriveSearchField(
                  icon: departure['leadingIcon']?.toString() ?? 'location',
                  value: displayLocation,
                  placeholder:
                      departure['placeholder']?.toString() ??
                      'City, airport or station',
                  onTap: () {
                    ref.read(homeSearchOpenPanelProvider.notifier).state =
                        openPanel == 'departure' ? null : 'departure';
                  },
                ),

                if (openPanel == 'departure') ...[
                  const SizedBox(height: 10),
                  QDriveLocationDropdown(
                    data: departure,
                    selectedTab: selectedTab,
                    returnElsewhere: roundTrip,
                    onTabChanged: (tab) {
                      ref.read(homeSearchSelectedTabProvider.notifier).state =
                          tab;
                    },
                    onReturnElsewhereChanged: (value) {
                      ref.read(homeSearchRoundTripProvider.notifier).state =
                          value;
                      ref
                              .read(homeSearchReturnElsewhereProvider.notifier)
                              .state =
                          value;
                    },
                    onItemSelected: (item) {
                      ref
                              .read(homeSearchSelectedLocationProvider.notifier)
                              .state =
                          item;
                      ref.read(homeSearchOpenPanelProvider.notifier).state =
                          null;
                    },
                  ),
                ],

                if (!roundTrip) ...[
                  const SizedBox(height: 18),

                  Text(
                    returnLocation['label']?.toString() ?? 'Return Location',
                    style: _labelStyle,
                  ),

                  const SizedBox(height: 10),

                  QDriveSearchField(
                    icon:
                        returnLocation['leadingIcon']?.toString() ?? 'location',
                    value: displayReturnLocation,
                    placeholder:
                        returnLocation['placeholder']?.toString() ??
                        'City, airport or station',
                    onTap: () {
                      ref
                          .read(homeSearchOpenPanelProvider.notifier)
                          .state = openPanel == 'returnLocation'
                          ? null
                          : 'returnLocation';
                    },
                  ),

                  if (openPanel == 'returnLocation') ...[
                    const SizedBox(height: 10),
                    QDriveLocationDropdown(
                      data: departure,
                      selectedTab: selectedTab,
                      returnElsewhere: roundTrip,
                      onTabChanged: (tab) {
                        ref.read(homeSearchSelectedTabProvider.notifier).state =
                            tab;
                      },
                      onReturnElsewhereChanged: (value) {
                        ref.read(homeSearchRoundTripProvider.notifier).state =
                            value;
                        ref
                                .read(
                                  homeSearchReturnElsewhereProvider.notifier,
                                )
                                .state =
                            value;
                      },
                      onItemSelected: (item) {
                        ref
                                .read(
                                  homeSearchSelectedReturnLocationProvider
                                      .notifier,
                                )
                                .state =
                            item;
                        ref.read(homeSearchOpenPanelProvider.notifier).state =
                            null;
                      },
                    ),
                  ],
                ],
                const SizedBox(height: 18),

                Text(
                  pickup['label']?.toString() ?? 'Add date and time',
                  style: _labelStyle,
                ),
                const SizedBox(height: 10),

                QDriveSearchField(
                  icon: pickup['leadingIcon']?.toString() ?? 'calendar',
                  value: pickupDate,
                  placeholder:
                      pickup['placeholder']?.toString() ?? 'Add date and time',
                  onTap: () {
                    ref.read(homeSearchOpenPanelProvider.notifier).state =
                        openPanel == 'pickup' ? null : 'pickup';
                  },
                ),

                if (openPanel == 'pickup') ...[
                  const SizedBox(height: 10),
                  QDriveCalendarDropdown(
                    data: pickup,
                    selectedDayProvider: homeSearchSelectedPickupDayProvider,
                    selectedTimeProvider: homeSearchSelectedPickupTimeProvider,
                    onDone: (value) {
                      ref.read(homeSearchPickupDateProvider.notifier).state =
                          value;
                      ref.read(homeSearchOpenPanelProvider.notifier).state =
                          null;
                    },
                  ),
                ],

                const SizedBox(height: 18),

                Text(
                  dropoff['label']?.toString() ?? 'Add date and time',
                  style: _labelStyle,
                ),
                const SizedBox(height: 10),

                QDriveSearchField(
                  icon: dropoff['leadingIcon']?.toString() ?? 'calendar',
                  value: returnDate,
                  placeholder:
                      dropoff['placeholder']?.toString() ?? 'Add date and time',
                  onTap: () {
                    ref.read(homeSearchOpenPanelProvider.notifier).state =
                        openPanel == 'dropoff' ? null : 'dropoff';
                  },
                ),

                if (openPanel == 'dropoff') ...[
                  const SizedBox(height: 10),
                  QDriveCalendarDropdown(
                    data: dropoff,
                    selectedDayProvider: homeSearchSelectedReturnDayProvider,
                    selectedTimeProvider: homeSearchSelectedReturnTimeProvider,
                    onDone: (value) {
                      ref.read(homeSearchReturnDateProvider.notifier).state =
                          value;
                      ref.read(homeSearchOpenPanelProvider.notifier).state =
                          null;
                    },
                  ),
                ],

                const SizedBox(height: 20),

                _FilterRow(
                  withDriver: withDriver,
                  onChanged: (value) {
                    ref.read(homeSearchWithDriverProvider.notifier).state =
                        value;
                  },
                ),

                const SizedBox(height: 18),

                if (isCompact) ...[
                  _SearchButton(
                    label: props['buttonLabel']?.toString() ?? 'Search',
                    onTap: () {
                      debugPrint('Search cars');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ScreenBuilder(json: vehicleListJson),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  _MoreFilters(
  label: moreFilters['label']?.toString() ?? 'More filters',
  icon: moreFilters['icon']?.toString() ?? 'search',
  onTap: handleMoreFiltersTap,
),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child:_MoreFilters(
  label: moreFilters['label']?.toString() ?? 'More filters',
  icon: moreFilters['icon']?.toString() ?? 'search',
  onTap: handleMoreFiltersTap,
),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: _SearchButton(
                          label: props['buttonLabel']?.toString() ?? 'Search',
                          onTap: () {
                            debugPrint('Search cars');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  static Map<dynamic, dynamic> _map(dynamic value) {
    if (value is Map) {
      return Map<dynamic, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static const TextStyle _labelStyle = TextStyle(
    fontSize: 13,
    height: 1,
    color: Color(0xFF060606),
    fontWeight: FontWeight.w600,
  );
}

class _TopLabelRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _TopLabelRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              height: 1,
              color: Color(0xFF060606),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Text(
          'Round-trip?',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF111111),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        QDriveMiniToggle(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  final bool withDriver;
  final ValueChanged<bool> onChanged;

  const _FilterRow({required this.withDriver, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Filter:',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF111111),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        _FilterPill(
          label: 'Without Driver',
          selected: !withDriver,
          onTap: () => onChanged(false),
        ),
        const SizedBox(width: 8),
        _FilterPill(
          label: 'With Driver',
          selected: withDriver,
          onTap: () => onChanged(true),
        ),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1D1D1F) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? const Color(0xFF1D1D1F) : const Color(0xFFE2E2E2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Colors.white : const Color(0xFF111111),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MoreFilters extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback onTap;

  const _MoreFilters({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElementIcons.show(
                  context,
                  icon,
                  size: 18,
                  color: const Color(0xFF6B7280),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SearchButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1D1D1F),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            '$label  →',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
