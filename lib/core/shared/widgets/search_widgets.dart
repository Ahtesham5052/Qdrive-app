import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class QDriveSearchField extends StatelessWidget {
  final String icon;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  // Dark mode support for filter sheet / dark booking panels.
  final bool dark;

  // Optional trailing icon. Keep chevron by default for dropdown behaviour.
  final String trailingIcon;

  const QDriveSearchField({
    super.key,
    required this.icon,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.dark = false,
    this.trailingIcon = 'chevron_down',
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.trim().isNotEmpty;
    final text = hasValue ? value! : placeholder;

    final bgColor = dark ? const Color(0xFF050505) : const Color(0xFFF4F4F5);

    final borderColor = dark ? const Color(0xFF2B2B2B) : Colors.transparent;

    final iconColor = dark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF);

    final textColor = dark
        ? hasValue
              ? Colors.white
              : const Color(0xFFB8B8B8)
        : hasValue
        ? const Color(0xFF202124)
        : const Color(0xFFA4A7AE);

    final trailingBg = dark ? const Color(0xFF171717) : const Color(0xFFE9EAEC);

    final trailingColor = dark
        ? const Color(0xFFB8B8B8)
        : const Color(0xFF8F939A);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              ElementIcons.show(context, icon, size: 17, color: iconColor),

              const SizedBox(width: 13),

              Expanded(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(
                width: 31,
                height: 31,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: trailingBg,
                  shape: BoxShape.circle,
                ),
                child: ElementIcons.show(
                  context,
                  trailingIcon,
                  size: 18,
                  color: trailingColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QDriveLocationDropdown extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  final String selectedTab;
  final bool returnElsewhere;
  final ValueChanged<String> onTabChanged;
  final ValueChanged<bool> onReturnElsewhereChanged;
  final ValueChanged<String> onItemSelected;

  const QDriveLocationDropdown({
    required this.data,
    required this.selectedTab,
    required this.returnElsewhere,
    required this.onTabChanged,
    required this.onReturnElsewhereChanged,
    required this.onItemSelected,
  });

  @override
  State<QDriveLocationDropdown> createState() => _QDriveLocationDropdownState();
}

class _QDriveLocationDropdownState extends State<QDriveLocationDropdown> {
  final ScrollController _locationController = ScrollController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = List<Map<dynamic, dynamic>>.from(widget.data['tabs'] ?? []);
    final airportItems = List<String>.from(widget.data['airportItems'] ?? []);
    final stationItems = List<String>.from(widget.data['stationItems'] ?? []);

    final items = widget.selectedTab == 'station' ? stationItems : airportItems;
    final icon = widget.selectedTab == 'station' ? 'train' : 'plane';

    return Container(
      height: 260,
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1D1D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 40,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  ...tabs.map((tab) {
                    final id = tab['id']?.toString() ?? '';
                    final selected = id == widget.selectedTab;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: QDriveSmallTab(
                        label: tab['label']?.toString() ?? '',
                        selected: selected,
                        onTap: () => widget.onTabChanged(id),
                      ),
                    );
                  }),

                  const SizedBox(width: 8),

                  Container(
                    height: 34,
                    width: 190,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: const Color(0xFF454545)),
                    ),
                    child: Row(
                      children: [
                        QDriveMiniToggle(
                          value: widget.returnElsewhere,
                          dark: true,
                          onChanged: widget.onReturnElsewhereChanged,
                        ),

                        const SizedBox(width: 8),

                        const Expanded(
                          child: Text(
                            'Add return location',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFF353535)),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              controller: _locationController,
              child: ListView.builder(
                controller: _locationController,
                primary: false,

                padding: const EdgeInsets.only(top: 8, right: 8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final selected = index == 3;

                  return InkWell(
                    onTap: () => widget.onItemSelected(items[index]),
                    child: Container(
                      height: 37,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF3E3E3E)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          ElementIcons.show(
                            context,
                            icon,
                            size: 17,
                            color: const Color(0xFFC9C9C9),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              items[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QDriveCalendarDropdown extends ConsumerStatefulWidget {
  final Map<dynamic, dynamic> data;
  final StateProvider<int?> selectedDayProvider;
  final StateProvider<String?> selectedTimeProvider;
  final ValueChanged<String> onDone;

  const QDriveCalendarDropdown({
    super.key,
    required this.data,
    required this.selectedDayProvider,
    required this.selectedTimeProvider,
    required this.onDone,
  });

  @override
  ConsumerState<QDriveCalendarDropdown> createState() =>
      _CalendarDropdownState();
}

class _CalendarDropdownState extends ConsumerState<QDriveCalendarDropdown> {
  final ScrollController _timeScrollController = ScrollController();

  late DateTime _visibleMonth;
  late bool _dark;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month, 1);
  }

  @override
  void dispose() {
    _timeScrollController.dispose();
    super.dispose();
  }

  bool _isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  bool _isPreviousMonthDisabled() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    final previousMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month - 1,
      1,
    );

    return previousMonth.isBefore(currentMonth);
  }

  void _goPreviousMonth() {
    if (_isPreviousMonthDisabled()) return;

    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    });
  }

  void _goNextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    });
  }

  String _monthLabel(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatDateTime(DateTime date, String time) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];

    return '$day $month ${date.year} $time';
  }

  @override
  Widget build(BuildContext context) {
    _dark = Theme.of(context).brightness == Brightness.dark;

    final selectedDay = ref.watch(widget.selectedDayProvider);
    final selectedTime = ref.watch(widget.selectedTimeProvider);

    final times = List<String>.from(widget.data['times'] ?? []);

    final selectedDate = selectedDay == null
        ? null
        : DateTime(_visibleMonth.year, _visibleMonth.month, selectedDay);

    final bg = _dark ? const Color(0xFF1D1D1D) : Colors.white;
    final border = _dark ? const Color(0xFF353535) : const Color(0xFFE0E0E0);
    final text = _dark ? Colors.white : const Color(0xFF111111);
    final muted = _dark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final divider = _dark ? const Color(0xFF353535) : const Color(0xFFE5E5E5);

    return Container(
      constraints: BoxConstraints(maxHeight: selectedDay == null ? 380 : 430),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_dark ? 0.22 : 0.09),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _monthLabel(_visibleMonth),
                    style: TextStyle(
                      fontSize: 13,
                      color: text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                QDriveMonthButton(
                  icon: Icons.chevron_left_rounded,
                  dark: _dark,
                  enabled: !_isPreviousMonthDisabled(),
                  onTap: _goPreviousMonth,
                ),
                const SizedBox(width: 8),
                QDriveMonthButton(
                  icon: Icons.chevron_right_rounded,
                  dark: _dark,
                  enabled: true,
                  onTap: _goNextMonth,
                ),
              ],
            ),
          ),

          QDriveCalendarGrid(
            visibleMonth: _visibleMonth,
            selectedDay: selectedDay,
            dark: _dark,
            onSelected: (date) {
              ref.read(widget.selectedDayProvider.notifier).state = date.day;
            },
          ),

          Divider(height: 1, color: divider),

          Container(
            height: 35,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'PICK-UP TIME',
              style: TextStyle(
                fontSize: 11,
                color: muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          if (selectedDay == null)
            Container(
              height: 40,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Choose a date to see available times.',
                style: TextStyle(
                  fontSize: 13,
                  color: muted,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          else
            Flexible(
              child: Scrollbar(
                controller: _timeScrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: _timeScrollController,
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(12, 0, 16, 12),
                  itemCount: times.length,
                  itemBuilder: (context, index) {
                    final time = times[index];
                    final selected = time == selectedTime;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          if (selectedDate == null) return;

                          ref.read(widget.selectedTimeProvider.notifier).state =
                              time;

                          widget.onDone(_formatDateTime(selectedDate, time));
                        },
                        child: Container(
                          height: 36,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: selected
                                ? _dark
                                      ? const Color(0xFF333333)
                                      : const Color(0xFFF0F0F0)
                                : bg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: border),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class QDriveCalendarGrid extends StatelessWidget {
  final DateTime visibleMonth;
  final int? selectedDay;
  final ValueChanged<DateTime> onSelected;
  final bool dark;

  const QDriveCalendarGrid({
    super.key,
    required this.visibleMonth,
    required this.selectedDay,
    required this.onSelected,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    const weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final firstDay = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final daysInMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month + 1,
      0,
    ).day;

    final leadingEmptyCells = firstDay.weekday - 1;
    final totalCells = leadingEmptyCells + daysInMonth;
    final rowCount = (totalCells / 7).ceil();
    final cellCount = rowCount * 7;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final muted = dark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF);
    final text = dark ? Colors.white : const Color(0xFF111111);
    final disabledText = dark
        ? const Color(0xFF555555)
        : const Color(0xFFD1D5DB);
    final selectedBg = dark ? Colors.white : const Color(0xFF111111);
    final selectedText = dark ? const Color(0xFF111111) : Colors.white;
    final todayBg = dark ? const Color(0xFF2B2B2B) : const Color(0xFFF4F4F4);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 34,
            child: Row(
              children: weekDays.map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 11,
                        color: muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          GridView.builder(
            primary: false,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cellCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.35,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - leadingEmptyCells + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(
                visibleMonth.year,
                visibleMonth.month,
                dayNumber,
              );

              final disabled = date.isBefore(today);
              final isSelected = selectedDay == dayNumber;

              final isToday =
                  today.year == date.year &&
                  today.month == date.month &&
                  today.day == date.day;

              return InkWell(
                onTap: disabled ? null : () => onSelected(date),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedBg
                        : isToday
                        ? todayBg
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(
                            color: dark ? Colors.white : Colors.black,
                            width: 1,
                          )
                        : null,
                  ),
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontSize: 12,
                      color: disabled
                          ? disabledText
                          : isSelected
                          ? selectedText
                          : text,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class QDriveMonthButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool dark;
  final bool enabled;

  const QDriveMonthButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.dark = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final border = dark ? const Color(0xFF454545) : const Color(0xFFE1E1E1);
    final bg = dark ? const Color(0xFF252525) : Colors.white;

    final iconColor = enabled
        ? dark
              ? Colors.white
              : const Color(0xFF111111)
        : dark
        ? const Color(0xFF555555)
        : const Color(0xFFC7CBD1);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}

class QDriveMiniToggle extends StatelessWidget {
  final bool value;
  final bool dark;
  final ValueChanged<bool> onChanged;

  const QDriveMiniToggle({
    required this.value,
    required this.onChanged,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 34,
        height: 19,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value
              ? Colors.black
              : dark
              ? const Color(0xFF3B3B3B)
              : const Color(0xFFE9EAEC),
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: value ? Colors.white : const Color(0xFFD4D6DA),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class QDriveSmallTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const QDriveSmallTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.black : const Color(0xFF2B2B2B),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 31,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFF444444)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
