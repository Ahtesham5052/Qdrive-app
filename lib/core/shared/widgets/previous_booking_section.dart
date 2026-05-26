import 'package:Qdrive/app/constants/app_constants.dart';
import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:flutter/material.dart';

class PreviousBookingsSection extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  const PreviousBookingsSection({super.key, required this.data});

  @override
  State<PreviousBookingsSection> createState() =>
      _PreviousBookingsSectionState();
}

class _PreviousBookingsSectionState extends State<PreviousBookingsSection> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'all';
  String _selectedSort = 'Latest First';
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _removeSortDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final props = Map<dynamic, dynamic>.from(widget.data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(widget.data['theme'] ?? {});
    final classes = ElementSettings.classList(widget.data['classes']);
    final actions = currentScreenJson['actions'] ?? {};

    print("PreviousBookingsSection data: ${actions}");

    final searchPlaceholder =
        props['searchPlaceholder']?.toString() ??
        'Search by booking ID or location...';

    final filters = _mapList(props['filters']);
    final sortOptions = List<String>.from(props['sortOptions'] ?? []);
    final items = _filteredBookings(_mapList(props['items']));

    return Container(
      margin: ElementSettings.margin(classes),
      padding: ElementSettings.padding(classes),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _searchField(
            context: context,
            theme: theme,
            placeholder: searchPlaceholder,
          ),

          const SizedBox(height: 12),

          _filterChips(context: context, theme: theme, filters: filters),

          const SizedBox(height: 18),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${items.length} ${items.length == 1 ? 'booking' : 'bookings'} found',
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(theme['countText']),
                  ),
                ),
              ),
              _sortDropdown(
                context: context,
                theme: theme,
                options: sortOptions,
              ),
            ],
          ),

          const SizedBox(height: 18),

          ...items.map((booking) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _bookingCard(
                context: context,
                theme: theme,
                props: props,
                booking: booking,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _searchField({
    required BuildContext context,
    required Map<dynamic, dynamic> theme,
    required String placeholder,
  }) {
    final searchClasses = ElementSettings.classList(theme['search']);
    final textClasses = ElementSettings.classList(theme['searchText']);
    final iconClasses = ElementSettings.classList(theme['searchIcon']);

    return Container(
      decoration: ElementSettings.decoration(context, searchClasses),
      padding: ElementSettings.padding(searchClasses),

      child: Row(
        children: [
          ElementIcons.show(
            context,
            'search',
            size: 20,
            color: ElementSettings.textColor(context, iconClasses),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: ElementSettings.textStyle(context, textClasses),
              cursorColor: ElementSettings.textColor(context, textClasses),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle:
                    ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['searchText']),
                    ).copyWith(
                      color: ElementSettings.textColor(context, iconClasses),
                    ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                setState(() {
                  _query = value.trim().toLowerCase();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChips({
    required BuildContext context,
    required Map<dynamic, dynamic> theme,
    required List<Map<dynamic, dynamic>> filters,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.asMap().entries.map((entry) {
          final index = entry.key;
          final filter = entry.value;

          final id = filter['id']?.toString() ?? '';
          final label = filter['label']?.toString() ?? '';

          final selected = id == _selectedFilter;

          final chipClasses = ElementSettings.classList(
            selected ? theme['activeChip'] : theme['chip'],
          );

          final textClasses = ElementSettings.classList(
            selected ? theme['activeChipText'] : theme['chipText'],
          );

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _selectedFilter = id;
                });
              },
              child: Container(
                padding: ElementSettings.padding(chipClasses),
                decoration: ElementSettings.decoration(context, chipClasses),
                child: Text(
                  label,
                  style: ElementSettings.textStyle(context, textClasses),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  final LayerLink _sortLayerLink = LayerLink();
  final GlobalKey _sortButtonKey = GlobalKey();
  OverlayEntry? _sortOverlayEntry;

  void _removeSortDropdown() {
    _sortOverlayEntry?.remove();
    _sortOverlayEntry = null;
  }

  Widget _sortDropdown({
    required BuildContext context,
    required Map<dynamic, dynamic> theme,
    required List<String> options,
  }) {
    final boxClasses = ElementSettings.classList(theme['sortBox']);
    final textClasses = ElementSettings.classList(theme['sortText']);

    return CompositedTransformTarget(
      link: _sortLayerLink,
      child: GestureDetector(
        key: _sortButtonKey,
        onTap: () {
          if (_sortOverlayEntry != null) {
            _removeSortDropdown();
            return;
          }

          final renderBox =
              _sortButtonKey.currentContext?.findRenderObject() as RenderBox?;

          if (renderBox == null) return;

          final buttonSize = renderBox.size;

          _sortOverlayEntry = OverlayEntry(
            builder: (_) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _removeSortDropdown,
                      behavior: HitTestBehavior.translucent,
                      child: const SizedBox.expand(),
                    ),
                  ),
                  CompositedTransformFollower(
                    link: _sortLayerLink,
                    showWhenUnlinked: false,
                    targetAnchor: Alignment.bottomRight,
                    followerAnchor: Alignment.topRight,
                    offset: const Offset(0, 6),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: buttonSize.width,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1C),
                          border: Border.all(color: const Color(0xFF5C5C5C)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: options.map((option) {
                            final isSelected = option == _selectedSort;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedSort = option;
                                });

                                _removeSortDropdown();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                color: isSelected
                                    ? const Color(0xFF2878D0)
                                    : Colors.transparent,
                                child: Text(
                                  option,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );

          Overlay.of(context).insert(_sortOverlayEntry!);
        },
        child: Container(
          padding: ElementSettings.padding(boxClasses),

          decoration: ElementSettings.decoration(context, boxClasses),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedSort,
                style: ElementSettings.textStyle(context, textClasses),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: ElementSettings.textColor(context, textClasses),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<dynamic, dynamic>? _jsonAction({
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> booking,
    required String itemActionRefKey,
    required String fallbackActionRefKey,
  }) {
    final actions = Map<dynamic, dynamic>.from(
      currentScreenJson['actions'] ?? {},
    );

    final itemActionRef = booking[itemActionRefKey]?.toString() ?? '';
    final fallbackActionRef = props[fallbackActionRefKey]?.toString() ?? '';

    final actionRef = itemActionRef.isNotEmpty
        ? itemActionRef
        : fallbackActionRef;

    if (actionRef.isEmpty) return null;

    final rawAction = actions[actionRef];

    if (rawAction is! Map) {
      debugPrint('PreviousBookingsSection action not found: $actionRef');
      return null;
    }

    final action = Map<dynamic, dynamic>.from(rawAction);
    final params = Map<dynamic, dynamic>.from(action['params'] ?? {});

    params['bookingId'] = booking['id'];
    params['booking'] = booking;

    action['params'] = params;

    return action;
  }

  Widget _bookingCard({
    required BuildContext context,
    required Map<dynamic, dynamic> theme,
    required Map<dynamic, dynamic> props,

    required Map<dynamic, dynamic> booking,
  }) {
    final cardClasses = ElementSettings.classList(theme['card']);
    final dividerColor = ElementSettings.background(
      context,
      ElementSettings.classList(theme['divider']),
    );

    final showPrimaryAction = (booking['primaryAction'] ?? '')
        .toString()
        .isNotEmpty;

    final showRating = booking['showRating'] == true;

    return Container(
      decoration: ElementSettings.decoration(context, cardClasses),
      padding: ElementSettings.padding(cardClasses),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['id']?.toString() ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['bookingId']),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      booking['dateTime']?.toString() ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['date']),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                booking['statusLabel']?.toString() ?? '',
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['status']),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _bookingImage(context, theme, booking['image']?.toString() ?? ''),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['vehicleName']?.toString() ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['vehicleName']),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        ElementIcons.show(
                          context,
                          'location',
                          size: 13,
                          color: ElementSettings.textColor(
                            context,
                            ElementSettings.classList(theme['routeIcon']),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            booking['route']?.toString() ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ElementSettings.textStyle(
                              context,
                              ElementSettings.classList(theme['route']),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Container(height: 1, color: dividerColor),
          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['price']?.toString() ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['price']),
                      ),
                    ),
                    Text(
                      booking['priceType']?.toString() ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['priceType']),
                      ),
                    ),
                  ],
                ),
              ),

              _smallButton(
                context: context,
                theme: theme,
                label: 'View',
                icon: 'eye',
                dark: true,
                action: _jsonAction(
                  props: props,
                  booking: booking,
                  itemActionRefKey: 'viewActionRef',
                  fallbackActionRefKey: 'viewActionRef',
                ),
              ),

              if (showPrimaryAction) ...[
                const SizedBox(width: 8),
                _smallButton(
                  context: context,
                  theme: theme,
                  label: booking['primaryAction']?.toString() ?? '',
                  icon: booking['primaryActionType'] == 'book_again'
                      ? 'refresh'
                      : 'chevron_right',
                  dark: false,
                  action: _jsonAction(
                    props: props,
                    booking: booking,
                    itemActionRefKey: 'primaryActionRef',
                    fallbackActionRefKey: 'bookAgainActionRef',
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 14),

          if (showRating)
            Row(
              children: [
                Expanded(child: _receiptButton(context, theme, props, booking)),
                const SizedBox(width: 8),
                Expanded(child: _ratingBox(context, theme, booking)),
              ],
            )
          else
            _receiptButton(context, theme, props, booking),
        ],
      ),
    );
  }

  Widget _bookingImage(
    BuildContext context,
    Map<dynamic, dynamic> theme,
    String imageUrl,
  ) {
    final imageClasses = ElementSettings.classList(theme['image']);

    return ClipRRect(
      borderRadius: ElementSettings.radius(imageClasses),
      child: Image.network(
        imageUrl,
        width: 58,
        height: 46,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: 58,
            height: 46,
            decoration: ElementSettings.decoration(context, imageClasses),
            alignment: Alignment.center,
            child: Icon(
              Icons.directions_car,
              size: 20,
              color: ElementSettings.textColor(
                context,
                ElementSettings.classList(theme['routeIcon']),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _smallButton({
    required BuildContext context,
    required Map<dynamic, dynamic> theme,
    required String label,
    required String icon,
    required bool dark,
    required Map<dynamic, dynamic>? action,
  }) {
    final buttonClasses = ElementSettings.classList(
      dark ? theme['darkButton'] : theme['lightButton'],
    );

    final textClasses = ElementSettings.classList(
      dark ? theme['darkButtonText'] : theme['lightButtonText'],
    );

    final iconClasses = ElementSettings.classList(
      dark ? theme['darkButtonIcon'] : theme['lightButtonIcon'],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (action == null) return;
        ActionHandler.handle(context, action);
      },
      child: Container(
        padding: ElementSettings.padding(buttonClasses),
        decoration: ElementSettings.decoration(context, buttonClasses),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElementIcons.show(
              context,
              icon,
              size: 14,
              color: ElementSettings.textColor(context, iconClasses),
            ),
            const SizedBox(width: 7),
            Text(label, style: ElementSettings.textStyle(context, textClasses)),
          ],
        ),
      ),
    );
  }

  Widget _receiptButton(
    BuildContext context,
    Map<dynamic, dynamic> theme,
    Map<dynamic, dynamic> props,
    Map<dynamic, dynamic> booking,
  ) {
    final buttonClasses = ElementSettings.classList(theme['receiptButton']);
    final textClasses = ElementSettings.classList(theme['receiptText']);
    final iconClasses = ElementSettings.classList(theme['receiptIcon']);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ActionHandler.handle(
          context,
          _jsonAction(
            props: props,
            booking: booking,
            itemActionRefKey: 'receiptActionRef',
            fallbackActionRefKey: 'downloadReceiptActionRef',
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: ElementSettings.padding(buttonClasses),
        decoration: ElementSettings.decoration(context, buttonClasses),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElementIcons.show(
              context,
              'upload',
              size: 14,
              color: ElementSettings.textColor(context, iconClasses),
            ),
            const SizedBox(width: 7),
            Text(
              'Receipt',
              style: ElementSettings.textStyle(context, textClasses),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingBox(
    BuildContext context,
    Map<dynamic, dynamic> theme,
    Map<dynamic, dynamic> booking,
  ) {
    final boxClasses = ElementSettings.classList(theme['ratingBox']);
    final textClasses = ElementSettings.classList(theme['ratingText']);
    final iconClasses = ElementSettings.classList(theme['ratingIcon']);

    return Container(
      alignment: Alignment.center,
      padding: ElementSettings.padding(boxClasses),
      decoration: ElementSettings.decoration(context, boxClasses),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElementIcons.show(
            context,
            'star',
            size: 14,
            color: ElementSettings.textColor(context, iconClasses),
          ),
          const SizedBox(width: 6),
          Text(
            booking['rating']?.toString() ?? '',
            style: ElementSettings.textStyle(context, textClasses),
          ),
        ],
      ),
    );
  }

  List<Map<dynamic, dynamic>> _filteredBookings(
    List<Map<dynamic, dynamic>> items,
  ) {
    var results = items.where((item) {
      final status = item['status']?.toString() ?? '';

      final matchesFilter =
          _selectedFilter == 'all' || status == _selectedFilter;

      final haystack =
          '${item['id']} ${item['vehicleName']} ${item['route']} ${item['statusLabel']}'
              .toLowerCase();

      final matchesSearch = _query.isEmpty || haystack.contains(_query);

      return matchesFilter && matchesSearch;
    }).toList();

    results.sort((a, b) {
      final aDate =
          DateTime.tryParse(
            a['dateTime']?.toString().replaceFirst(' ', 'T') ?? '',
          ) ??
          DateTime(1900);

      final bDate =
          DateTime.tryParse(
            b['dateTime']?.toString().replaceFirst(' ', 'T') ?? '',
          ) ??
          DateTime(1900);

      if (_selectedSort == 'Oldest First') {
        return aDate.compareTo(bDate);
      }

      return bDate.compareTo(aDate);
    });

    return results;
  }

  List<Map<dynamic, dynamic>> _mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();
  }
}
