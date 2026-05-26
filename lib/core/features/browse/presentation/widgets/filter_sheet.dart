
import 'package:Qdrive/app/constants/app_constants.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/shared/widgets/search_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/shared/providers/vehicle_filter_provider.dart';

// ==========================================
// VEHICLE FILTER SHEET LOCAL UI STATE
// ==========================================
//
// These providers control only the temporary open/close state inside the sheet.
// Actual selected filter values stay in vehicleFilterProvider.

final vehicleFilterSheetOpenPanelProvider = StateProvider<String?>((ref) {
  return null;
});

final vehicleFilterSheetLocationTabProvider = StateProvider<String>((ref) {
  return 'airport';
});

final vehicleFilterSheetReturnElsewhereProvider = StateProvider<bool>((ref) {
  return false;
});

final vehicleFilterSheetPickupDayProvider = StateProvider<int?>((ref) {
  return null;
});

final vehicleFilterSheetReturnDayProvider = StateProvider<int?>((ref) {
  return null;
});

final vehicleFilterSheetPickupTimeProvider = StateProvider<String?>((ref) {
  return null;
});

final vehicleFilterSheetReturnTimeProvider = StateProvider<String?>((ref) {
  return null;
});

// ==========================================
// VEHICLE FILTER SHEET
// ==========================================
//
// Reuses:
// - QDriveSearchField
// - QDriveLocationDropdown
// - QDriveCalendarDropdown
//
// Important:
// - Do not render this through ScreenBuilder inside the bottom sheet.
// - Open it directly through ElementRenderer in ActionHandler.
// - This avoids extra ScreenBuilder/LayoutView padding.

class VehicleFilterSheet extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const VehicleFilterSheet({super.key, required this.data});

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color _bgPage = Color(0xFF111111);
  static Color _bgCard = Color(0xFF171717);
  static Color _bgInput = Color(0xFF050505);
  static Color _border = Color(0xFF2B2B2B);
  static Color _borderSoft = Color(0xFF353535);
  static Color _muted = Color(0xFF8F8F8F);
  static Color _mutedText = Color(0xFF9A9A9A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);

    _bgPage = dark ? Color(0xFF111111) : Colors.white;
    _bgCard = dark ? Color(0xFF171717) : Colors.white;
    _bgInput = dark ? Color(0xFF050505) : Colors.white;
    _border = Color(0xFF2B2B2B);
    _borderSoft = Color(0xFF353535);
    _muted = Color(0xFF8F8F8F);
    _mutedText = Color(0xFF9A9A9A);
    // ========================================
    // Props from resolved JSON bind: content.sheet
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    final collectionDropoffField = _map(props['collectionDropoffField']);

    // ========================================
    // Shared filter state
    // ========================================

    final filter = ref.watch(vehicleFilterProvider);
    final matchedCount = ref.watch(vehicleMatchedCountProvider);

    // ========================================
    // Local panel state
    // ========================================

    final openPanel = ref.watch(vehicleFilterSheetOpenPanelProvider);
    final selectedLocationTab = ref.watch(
      vehicleFilterSheetLocationTabProvider,
    );
    final returnElsewhere = ref.watch(
      vehicleFilterSheetReturnElsewhereProvider,
    );

    // ========================================
    // JSON content
    // ========================================

    final title = props['title']?.toString() ?? 'Book a vehicle';

    final accountTabs = _mapList(props['accountTabs']);

    final locationPicker = _map(props['locationPicker']);
    final pickupCalendar = _map(props['pickupCalendar']);
    final returnCalendar = _map(props['returnCalendar']);

    final vehicleCategory = _map(props['vehicleCategory']);
    final transmission = _map(props['transmission']);
    final seats = _map(props['seats']);
    final budget = _map(props['budget']);

    final personalFooter = _map(props['personalFooter']);
    final businessFooter = _map(props['businessFooter']);

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.94,
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              color: _bgPage,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  // ==================================
                  // Scrollable content
                  // ==================================
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          _accountTabs(
                            context: context,
                            ref: ref,
                            items: accountTabs,
                            selectedId: filter.accountType,
                          ),

                          const SizedBox(height: 14),

                          _sheetTitle(title, context),

                          const SizedBox(height: 8),

                          _bookingFields(
                            context: context,
                            ref: ref,
                            filter: filter,
                            openPanel: openPanel,
                            locationPicker: locationPicker,
                            collectionDropoffField: collectionDropoffField,
                            pickupCalendar: pickupCalendar,
                            returnCalendar: returnCalendar,
                            selectedLocationTab: selectedLocationTab,
                            returnElsewhere: returnElsewhere,
                            dark: dark,
                          ),

                          const SizedBox(height: 24),

                          _chipSection(
                            context: context,
                            title:
                                vehicleCategory['title']?.toString() ??
                                'Vehicle category',
                            items: _mapList(vehicleCategory['items']),
                            selectedId: filter.vehicleCategory,
                            onTap: (id) {
                              ref
                                  .read(vehicleFilterProvider.notifier)
                                  .setVehicleCategory(id);
                            },
                          ),

                          const SizedBox(height: 24),

                          _segmentSection(
                            context: context,
                            title:
                                transmission['title']?.toString() ??
                                'Transmission',
                            items: _mapList(transmission['items']),
                            selectedId: filter.transmission,
                            onTap: (id) {
                              ref
                                  .read(vehicleFilterProvider.notifier)
                                  .setTransmission(id);
                            },
                          ),

                          const SizedBox(height: 24),

                          _chipSection(
                            context: context,
                            title:
                                seats['title']?.toString() ?? 'Number of seats',
                            items: _mapList(seats['items']),
                            selectedId: filter.seats,
                            onTap: (id) {
                              ref
                                  .read(vehicleFilterProvider.notifier)
                                  .setSeats(id);
                            },
                          ),

                          const SizedBox(height: 24),

                          _budgetSection(
                            context: context,
                            ref: ref,
                            budget: budget,
                            min: filter.budgetMin,
                            max: filter.budgetMax,
                            dark: dark,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ==================================
                  // Sticky footer
                  // ==================================
                  _footer(
                    context: context,
                    filter: filter,
                    matchedCount: matchedCount,
                    personalFooter: personalFooter,
                    businessFooter: businessFooter,
                    dark: dark
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => Navigator.of(context).maybePop(),
        child: const SizedBox(
          width: 32,
          height: 32,
          child: Icon(Icons.close_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _sheetTitle(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: ElementSettings.textColor(context, ["text-primary"]),

        fontSize: 20,
        height: 2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ==========================================
  // TOP BAR
  // ==========================================

  Widget _topBar(BuildContext context, String title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              height: 1.05,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF171717),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFF2B2B2B)),
            ),
            child: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // ACCOUNT TABS
  // ==========================================

  Widget _accountTabs({
    required BuildContext context,
    required WidgetRef ref,
    required List<Map<dynamic, dynamic>> items,
    required String selectedId,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: items.map((item) {
          final id = item['id']?.toString() ?? '';
          final selected = id == selectedId;

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                ref.read(vehicleFilterProvider.notifier).setAccountType(id);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElementIcons.show(
                      context,
                      item['icon'],
                      size: 16,
                      color: selected ? Colors.white : _muted,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      item['label']?.toString() ?? '',
                      style: TextStyle(
                        color: selected ? Colors.white : _muted,
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // BOOKING FIELDS
  // ==========================================
  //
  // This now reuses:
  // - QDriveSearchField
  // - QDriveLocationDropdown
  // - QDriveCalendarDropdown

  Widget _bookingFields({
    required BuildContext context,
    required WidgetRef ref,
    required VehicleFilterState filter,
    required String? openPanel,
    required Map<dynamic, dynamic> locationPicker,
    required Map<dynamic, dynamic> collectionDropoffField,
    required Map<dynamic, dynamic> pickupCalendar,
    required Map<dynamic, dynamic> returnCalendar,
    required String selectedLocationTab,
    required bool returnElsewhere,
    required bool dark,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================
          // Pickup location
          // ==================================
          _fieldLabel('Pickup location'),

          const SizedBox(height: 8),

          QDriveSearchField(
            dark: dark ? true : false,
            icon: 'location',
            value: filter.pickupLocation,
            placeholder: 'Enter pickup location',
            onTap: () {
              final notifier = ref.read(
                vehicleFilterSheetOpenPanelProvider.notifier,
              );

              notifier.state = openPanel == 'pickupLocation'
                  ? null
                  : 'pickupLocation';
            },
          ),

          if (openPanel == 'pickupLocation') ...[
            const SizedBox(height: 10),
            QDriveLocationDropdown(
              data: locationPicker,
              selectedTab: selectedLocationTab,
              returnElsewhere: returnElsewhere,
              onTabChanged: (tab) {
                ref.read(vehicleFilterSheetLocationTabProvider.notifier).state =
                    tab;
              },
              onReturnElsewhereChanged: (value) {
                ref
                        .read(
                          vehicleFilterSheetReturnElsewhereProvider.notifier,
                        )
                        .state =
                    value;
              },
              onItemSelected: (item) {
                ref
                    .read(vehicleFilterProvider.notifier)
                    .setPickupLocation(item);

                ref.read(vehicleFilterSheetOpenPanelProvider.notifier).state =
                    null;
              },
            ),
          ],

          // ==================================
          // Collection / drop-off location
          // Shows when Add return location is OFF
          // ==================================
          if (!returnElsewhere) ...[
            const SizedBox(height: 14),

            _fieldLabel(
              collectionDropoffField['label']?.toString() ??
                  'Collection / drop-off location',
            ),

            const SizedBox(height: 8),

            QDriveSearchField(
              dark: dark ? true : false,
              icon:
                  collectionDropoffField['leadingIcon']?.toString() ??
                  'location',
              value: filter.collectionDropoffLocation,
              placeholder:
                  collectionDropoffField['placeholder']?.toString() ??
                  'Different collection address',
              onTap: () {
                final notifier = ref.read(
                  vehicleFilterSheetOpenPanelProvider.notifier,
                );

                notifier.state = openPanel == 'collectionDropoffLocation'
                    ? null
                    : 'collectionDropoffLocation';
              },
            ),

            if (openPanel == 'collectionDropoffLocation') ...[
              const SizedBox(height: 10),
              QDriveLocationDropdown(
                data: locationPicker,
                selectedTab: selectedLocationTab,
                returnElsewhere: returnElsewhere,
                onTabChanged: (tab) {
                  ref
                          .read(vehicleFilterSheetLocationTabProvider.notifier)
                          .state =
                      tab;
                },
                onReturnElsewhereChanged: (value) {
                  ref
                          .read(
                            vehicleFilterSheetReturnElsewhereProvider.notifier,
                          )
                          .state =
                      value;
                },
                onItemSelected: (item) {
                  ref
                      .read(vehicleFilterProvider.notifier)
                      .setCollectionDropoffLocation(item);

                  ref.read(vehicleFilterSheetOpenPanelProvider.notifier).state =
                      null;
                },
              ),
            ],
          ],

          const SizedBox(height: 14),

          const Divider(height: 1, color: Color(0xFF2B2B2B)),

          const SizedBox(height: 14),

          // ==================================
          // Pickup Date & Time
          // ==================================
          _fieldLabel('Pickup Date & Time'),

          const SizedBox(height: 8),

          QDriveSearchField(
            dark: dark ? true : false,

            icon: 'calendar',
            trailingIcon: 'calendar',
            value: filter.pickupDateTime,
            placeholder: 'mm/dd/yyyy --:-- --',
            onTap: () {
              final notifier = ref.read(
                vehicleFilterSheetOpenPanelProvider.notifier,
              );

              notifier.state = openPanel == 'pickupDateTime'
                  ? null
                  : 'pickupDateTime';
            },
          ),

          if (openPanel == 'pickupDateTime') ...[
            const SizedBox(height: 10),
            QDriveCalendarDropdown(
              data: pickupCalendar,
              selectedDayProvider: vehicleFilterSheetPickupDayProvider,
              selectedTimeProvider: vehicleFilterSheetPickupTimeProvider,
              onDone: (value) {
                ref
                    .read(vehicleFilterProvider.notifier)
                    .setPickupDateTime(value);

                ref.read(vehicleFilterSheetOpenPanelProvider.notifier).state =
                    null;
              },
            ),
          ],

          const SizedBox(height: 14),

          // ==================================
          // Return Date & Time
          // ==================================
          _fieldLabel('Return Date & Time'),

          const SizedBox(height: 8),

          QDriveSearchField(
            dark: dark ? true : false,

            icon: 'calendar',
            trailingIcon: 'calendar',
            value: filter.returnDateTime,
            placeholder: 'mm/dd/yyyy --:-- --',
            onTap: () {
              final notifier = ref.read(
                vehicleFilterSheetOpenPanelProvider.notifier,
              );

              notifier.state = openPanel == 'returnDateTime'
                  ? null
                  : 'returnDateTime';
            },
          ),

          if (openPanel == 'returnDateTime') ...[
            const SizedBox(height: 10),
            QDriveCalendarDropdown(
              data: returnCalendar,
              selectedDayProvider: vehicleFilterSheetReturnDayProvider,
              selectedTimeProvider: vehicleFilterSheetReturnTimeProvider,
              onDone: (value) {
                ref
                    .read(vehicleFilterProvider.notifier)
                    .setReturnDateTime(value);

                ref.read(vehicleFilterSheetOpenPanelProvider.notifier).state =
                    null;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF9A9A9A),
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  // ==========================================
  // CHIP SECTION
  // ==========================================

  Widget _chipSection({
    required BuildContext context,
    required String title,
    required List<Map<dynamic, dynamic>> items,
    required String selectedId,
    required ValueChanged<String> onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final id = item['id']?.toString() ?? '';
            final selected = id == selectedId;

            return _filterChip(
              context: context,
              item: item,
              selected: selected,
              onTap: () => onTap(id),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ==========================================
  // SEGMENT SECTION
  // ==========================================

  Widget _segmentSection({
    required BuildContext context,
    required String title,
    required List<Map<dynamic, dynamic>> items,
    required String selectedId,
    required ValueChanged<String> onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        const SizedBox(height: 12),
        Row(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final id = item['id']?.toString() ?? '';
            final selected = id == selectedId;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onTap(id),
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? Colors.white
                            : const Color(0xFF353535),
                        width: selected ? 1.4 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElementIcons.show(
                          context,
                          item['icon'],
                          size: 20,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF8F8F8F),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item['label']?.toString() ?? '',
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : const Color(0xFF8F8F8F),
                            fontSize: 16,
                            fontWeight: selected
                                ? FontWeight.w800
                                : FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ==========================================
  // CHIP
  // ==========================================

  Widget _filterChip({
    required BuildContext context,
    required Map<dynamic, dynamic> item,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? Colors.white : _borderSoft,
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElementIcons.show(
              context,
              item['icon'],
              size: 15,
              color: selected ? Colors.white : _muted,
            ),
            const SizedBox(width: 7),
            Text(
              item['label']?.toString() ?? '',
              style: TextStyle(
                color: selected ? Colors.white : _muted,
                fontSize: 12.5,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BUDGET SECTION
  // ==========================================
  Widget _budgetSection({
    required BuildContext context,
    required WidgetRef ref,
    required Map<dynamic, dynamic> budget,
    required double min,
    required double max,
    required bool dark,
  }) {
    final histogram = budget['histogram'] is List
        ? List<num>.from(budget['histogram'])
        : <num>[];

    final maxBudget = budget['max'] is num
        ? (budget['max'] as num).toDouble()
        : 500.0;

    final safeMin = min.clamp(0, maxBudget).toDouble();
    final safeMax = max.clamp(0, maxBudget).toDouble();

    final mutedTextColor = dark
        ? const Color(0xFF8F8F8F)
        : const Color(0xFF6B7280);
    final activeColor = dark ? Colors.white : const Color(0xFF111827);
    final inactiveSliderColor = dark
        ? const Color(0xFF333333)
        : const Color(0xFFD1D5DB);
    final emptyBarColor = dark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE5E7EB);
    final outsideBarColor = dark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFD1D5DB);
    final insideBarColor = dark ? Colors.white : const Color(0xFF111827);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _sectionTitle(budget['title']?.toString() ?? 'Budget'),
            const SizedBox(width: 6),
            Text(
              budget['subtitle']?.toString() ?? '',
              style: TextStyle(
                color: mutedTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 48,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: histogram.asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value.toDouble();

              final barCount = histogram.length;
              final binSize = barCount == 0 ? 0.0 : maxBudget / barCount;

              final barStart = index * binSize;
              final barEnd = barStart + binSize;
              final barCenter = (barStart + barEnd) / 2;

              final isInsideSelectedRange =
                  barCenter >= safeMin && barCenter <= safeMax;

              final hasRealValue = value > 0;
              final h = hasRealValue ? value.clamp(6, 42).toDouble() : 2.0;

              final Color barColor;

              if (!hasRealValue) {
                barColor = emptyBarColor;
              } else if (isInsideSelectedRange) {
                barColor = insideBarColor;
              } else {
                barColor = outsideBarColor;
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOut,
                    height: h,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        RangeSlider(
          values: RangeValues(safeMin, safeMax),
          min: 0,
          max: maxBudget,
          divisions: 50,
          activeColor: activeColor,
          inactiveColor: inactiveSliderColor,
          labels: RangeLabels('£${safeMin.round()}', '£${safeMax.round()}'),
          onChanged: (values) {
            ref
                .read(vehicleFilterProvider.notifier)
                .setBudget(values.start, values.end);
          },
        ),

        Row(
          children: [
            Text(
              '£0',
              style: TextStyle(
                color: mutedTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '£${safeMax.round()}',
              style: TextStyle(
                color: activeColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
  // ==========================================
  // FOOTER
  // ==========================================

  Widget _footer({
    required BuildContext context,
    required VehicleFilterState filter,
    required int matchedCount,
    required Map<dynamic, dynamic> personalFooter,
    required Map<dynamic, dynamic> businessFooter,
    required bool dark
  }) {
    final isBusiness = filter.accountType == 'business';
    final footer = isBusiness ? businessFooter : personalFooter;
    final footerAction = footer['action'];

    print(
      "Rendering footer with matchedCount: $matchedCount, isBusiness: $isBusiness, footerAction: $footerAction",
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 390;
        final buttonWidth = compact ? 150.0 : 188.0;

        return Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          decoration: BoxDecoration(
            color: _bgCard,
            border: Border(top: BorderSide(color: Color(0xFF242424))),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: footerAction is Map
                      ? () {
                          ActionHandler.handle(
                            context,
                            Map<dynamic, dynamic>.from(footerAction),
                          );
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isBusiness
                              ? Icons.description_outlined
                              : Icons.lock_outline,
                          size: 22,
                          color: const Color(0xFF8F8F8F),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            footer['text']?.toString() ?? '',
                            maxLines: compact ? 3 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isBusiness
                                  ? dark ?Colors.white: Colors.black
                                  : const Color(0xFF9A9A9A),
                              fontSize: compact ? 12 : 13,
                              height: 1.35,
                              fontWeight: isBusiness
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              SizedBox(
                width: buttonWidth,
                height: 58,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    print(
                      "Apply filters button tapped with matchedCount: $currentScreenJson",
                    );
                    if (currentScreenJson != null &&
                        currentScreenJson["screen"].contains('home')) {
                      print("Current screen JSON: $currentScreenJson");
                      ActionHandler.handle(context, {
                        "type": "apply_vehicle_filters",
                        "params": {
                          "apiPath": "/vehicle_list.json",
                          "apiPathType": "GET",
                          "apiAction": "navigate",
                        },
                      });
                    } else {
                      ActionHandler.handle(context, {
                        "type": "apply_vehicle_filters",
                        "params": {},
                      });
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: dark ? Colors.white: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      matchedCount == 1
                          ? 'Show 1 result'
                          : 'Show $matchedCount results',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(
                        color: dark ? Colors.black: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // HELPERS
  // ==========================================

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: _mutedText,
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Map<dynamic, dynamic> _map(dynamic value) {
    if (value is Map) {
      return Map<dynamic, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  List<Map<dynamic, dynamic>> _mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();
  }
}
