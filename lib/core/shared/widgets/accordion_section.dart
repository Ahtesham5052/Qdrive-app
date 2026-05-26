import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:flutter/material.dart';

class AccordionSection extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  const AccordionSection({super.key, required this.data});

  @override
  State<AccordionSection> createState() => _AccordionSectionState();
}

class _AccordionSectionState extends State<AccordionSection> {
  int? openIndex;

  @override
  void initState() {
    super.initState();
    _setInitialOpenIndex();
  }

  @override
  void didUpdateWidget(covariant AccordionSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data) {
      _setInitialOpenIndex();
    }
  }

  void _setInitialOpenIndex() {
    final props = Map<dynamic, dynamic>.from(widget.data['props'] ?? {});
    final config = Map<dynamic, dynamic>.from(widget.data['config'] ?? {});

    final itemsKey = props['itemsKey']?.toString() ?? 'items';
    final rawItems = props[itemsKey] ?? props['items'];

    final items = rawItems is List
        ? rawItems.whereType<Map>().map((item) {
            return Map<dynamic, dynamic>.from(item);
          }).toList()
        : <Map<dynamic, dynamic>>[];

    final initialOpenIndex =
        props['initialOpenIndex'] ?? config['initialOpenIndex'];

    if (initialOpenIndex is int) {
      openIndex = initialOpenIndex;
      return;
    }

    final defaultExpandedIndex =
        props['defaultExpandedIndex'] ?? config['defaultExpandedIndex'];

    if (defaultExpandedIndex is int) {
      openIndex = defaultExpandedIndex;
      return;
    }

    final expandedIndex = items.indexWhere((item) => item['expanded'] == true);

    openIndex = expandedIndex >= 0 ? expandedIndex : null;
  }

  @override
  Widget build(BuildContext context) {
    final props = Map<dynamic, dynamic>.from(widget.data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(widget.data['theme'] ?? {});
    final classes = ElementSettings.classList(widget.data['classes']);

    final titleKey = props['titleKey']?.toString() ?? 'title';
    final itemsKey = props['itemsKey']?.toString() ?? 'items';
    final questionKey = props['questionKey']?.toString() ?? 'question';
    final answerKey = props['answerKey']?.toString() ?? 'answer';

    final title =
        props[titleKey]?.toString() ?? props['title']?.toString() ?? '';

    final rawItems = props[itemsKey] ?? props['items'];
    final items = rawItems is List
        ? rawItems.whereType<Map>().map((item) {
            return Map<dynamic, dynamic>.from(item);
          }).toList()
        : <Map<dynamic, dynamic>>[];

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool cardMode =
        props['variant'] == 'card' ||
        theme.containsKey('card') ||
        theme.containsKey('expandedCard') ||
        props['showTrailingIcon'] == true;

    final titleClasses = ElementSettings.classList(
      theme['title'] ?? theme['sectionTitle'],
    );

    final titleIconClasses = ElementSettings.classList(
      theme['titleIcon'] ?? theme['sectionIcon'] ?? theme['icon'],
    );

    final itemClasses = ElementSettings.classList(
      theme['item'] ?? theme['card'],
    );

    final expandedItemClasses = ElementSettings.classList(
      theme['expandedItem'] ??
          theme['expandedCard'] ??
          theme['item'] ??
          theme['card'],
    );

    final questionClasses = ElementSettings.classList(theme['question']);
    final answerClasses = ElementSettings.classList(theme['answer']);
    final iconClasses = ElementSettings.classList(theme['icon']);

    final titleAlign =
        props['titleAlign']?.toString() ?? (cardMode ? 'start' : 'center');

    final titleIcon = props['titleIcon']?.toString();
    final showTitleIcon = titleIcon != null && titleIcon.isNotEmpty;

    final showQuestionLeadingIcon = props['showQuestionLeadingIcon'] is bool
        ? props['showQuestionLeadingIcon'] == true
        : !cardMode;

    final showTrailingIcon = props['showTrailingIcon'] is bool
        ? props['showTrailingIcon'] == true
        : cardMode;

    final collapsedIcon =
        props['collapsedIcon']?.toString() ?? 'play_arrow_rounded';

    final expandedIcon =
        props['expandedIcon']?.toString() ?? 'keyboard_arrow_down_rounded';

    final trailingIcon = props['trailingIcon']?.toString() ?? 'help_outline';

    final expandedTrailingIcon =
        props['expandedTrailingIcon']?.toString() ?? trailingIcon;

    final itemSpacing = _doubleValue(props['itemSpacing'], 12);
    final questionMaxLines = _intValue(props['questionMaxLines'], 2);

    return Container(
      margin: ElementSettings.margin(classes),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: cardMode ? 16 : 18),
              child: Row(
                mainAxisAlignment: _headerMainAxis(titleAlign),
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showTitleIcon) ...[
                    ElementIcons.show(
                      context,
                      titleIcon,
                      size: 16,
                      color: ElementSettings.textColor(
                        context,
                        titleIconClasses,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      title,
                      textAlign: _textAlign(titleAlign),
                      style: ElementSettings.textStyle(context, titleClasses),
                    ),
                  ),
                ],
              ),
            ),

          ...List.generate(items.length, (index) {
            final item = items[index];

            final question = item[questionKey]?.toString() ?? '';
            final answer = item[answerKey]?.toString() ?? '';
            final isOpen = openIndex == index;

            final currentItemClasses = isOpen && expandedItemClasses.isNotEmpty
                ? expandedItemClasses
                : itemClasses;

            return Container(
              margin: EdgeInsets.only(
                bottom: index == items.length - 1 ? 0 : itemSpacing,
              ),
              decoration: ElementSettings.decoration(
                context,
                currentItemClasses,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: ElementSettings.radius(currentItemClasses),
                  onTap: () {
                    setState(() {
                      openIndex = isOpen ? null : index;
                    });
                  },
                  child: Padding(
                    padding: ElementSettings.padding(currentItemClasses),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (showQuestionLeadingIcon) ...[
                              _accordionIcon(
                                context: context,
                                icon: isOpen ? expandedIcon : collapsedIcon,
                                classes: iconClasses,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                            ],

                            Expanded(
                              child: Text(
                                question,
                                maxLines: questionMaxLines,
                                overflow: TextOverflow.ellipsis,
                                style: ElementSettings.textStyle(
                                  context,
                                  questionClasses,
                                ),
                              ),
                            ),

                            if (showTrailingIcon) ...[
                              const SizedBox(width: 10),
                              _accordionIcon(
                                context: context,
                                icon: isOpen
                                    ? expandedTrailingIcon
                                    : trailingIcon,
                                classes: iconClasses,
                                size: 18,
                              ),
                            ],
                          ],
                        ),

                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              answer,
                              style: ElementSettings.textStyle(
                                context,
                                answerClasses,
                              ),
                            ),
                          ),
                          crossFadeState: isOpen
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 180),
                          sizeCurve: Curves.easeOut,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _accordionIcon({
    required BuildContext context,
    required String icon,
    required List<String> classes,
    required double size,
  }) {
    return ElementIcons.show(
      context,
      icon,
      size: size,
      color: ElementSettings.textColor(context, classes),
    );
  }

  MainAxisAlignment _headerMainAxis(String value) {
    switch (value) {
      case 'center':
        return MainAxisAlignment.center;
      case 'end':
        return MainAxisAlignment.end;
      default:
        return MainAxisAlignment.start;
    }
  }

  TextAlign _textAlign(String value) {
    switch (value) {
      case 'center':
        return TextAlign.center;
      case 'end':
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.start;
    }
  }

  double _doubleValue(dynamic value, double fallback) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  int _intValue(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
