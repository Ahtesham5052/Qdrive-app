import 'package:flutter/material.dart';

class CarTravelPolicySheet extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const CarTravelPolicySheet({super.key, required this.data});

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final colours = _PolicySheetColours.fromTheme(dark);

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    final title = props['title']?.toString() ?? 'Car travel Policy';

    final inPolicy = _map(props['inPolicy']);
    final outOfPolicy = _map(props['outOfPolicy']);
    final policySetupMessage = _map(props['policySetupMessage']);

    final policyItems = _mapList(inPolicy['items']);

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.72,
          width: double.infinity,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel(
                          inPolicy['label']?.toString() ?? 'IN POLICY',
                          colours,
                        ),
                        const SizedBox(height: 10),
                        ...policyItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _PolicyRuleCard(
                              item: item,
                              colours: colours,
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                        _sectionLabel(
                          outOfPolicy['label']?.toString() ?? 'OUT OF POLICY',
                          colours,
                        ),
                        const SizedBox(height: 10),
                        _MessageCard(
                          text: outOfPolicy['text']?.toString() ?? '',
                          colours: colours,
                        ),
                        const SizedBox(height: 18),
                        _sectionLabel(
                          policySetupMessage['label']?.toString() ??
                              'POLICY SETUP MESSAGE',
                          colours,
                        ),
                        const SizedBox(height: 10),
                        _MessageCard(
                          text: policySetupMessage['text']?.toString() ?? '',
                          strongText:
                              policySetupMessage['strongText']?.toString(),
                          colours: colours,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(
    BuildContext context,
    String title,
    _PolicySheetColours colours,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: colours.title,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => Navigator.of(context).maybePop(),
            child: SizedBox(
              width: 34,
              height: 34,
              child: Icon(
                Icons.close_rounded,
                color: colours.title,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label, _PolicySheetColours colours) {
    return Text(
      label,
      style: TextStyle(
        color: colours.sectionLabel,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
    );
  }

  Map<dynamic, dynamic> _map(dynamic value) {
    if (value is Map) return Map<dynamic, dynamic>.from(value);
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

class _PolicyRuleCard extends StatefulWidget {
  final Map<dynamic, dynamic> item;
  final _PolicySheetColours colours;

  const _PolicyRuleCard({
    required this.item,
    required this.colours,
  });

  @override
  State<_PolicyRuleCard> createState() => _PolicyRuleCardState();
}

class _PolicyRuleCardState extends State<_PolicyRuleCard>
    with SingleTickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final colours = widget.colours;

    final title = item['title']?.toString() ?? '';
    final subtitle = item['subtitle']?.toString() ?? '';

    final moreLabel = item['linkLabel']?.toString() ?? 'More details';
    final hideLabel = item['hideLabel']?.toString() ?? 'Hide details';

    final detailText =
        item['detailText']?.toString() ??
        item['description']?.toString() ??
        '';

    final details = item['details'] is List
        ? List<dynamic>.from(item['details'])
        : <dynamic>[];

    final hasDetails = detailText.trim().isNotEmpty || details.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: colours.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colours.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colours.title,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: colours.body,
              fontSize: 12,
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hasDetails) ...[
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    expanded ? hideLabel : moreLabel,
                    style: TextStyle(
                      color: colours.link,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: colours.link,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _PolicyInlineDetails(
                        detailText: detailText,
                        details: details,
                        colours: colours,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ],
      ),
    );
  }
}

class _PolicyInlineDetails extends StatelessWidget {
  final String detailText;
  final List<dynamic> details;
  final _PolicySheetColours colours;

  const _PolicyInlineDetails({
    required this.detailText,
    required this.details,
    required this.colours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: colours.innerCardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colours.innerBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (detailText.trim().isNotEmpty)
            Text(
              detailText,
              style: TextStyle(
                color: colours.body,
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (details.isNotEmpty) ...[
            if (detailText.trim().isNotEmpty) const SizedBox(height: 12),
            ...details.map((detail) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: colours.link,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        detail.toString(),
                        style: TextStyle(
                          color: colours.body,
                          fontSize: 12,
                          height: 1.45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final String text;
  final String? strongText;
  final _PolicySheetColours colours;

  const _MessageCard({
    required this.text,
    this.strongText,
    required this.colours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: colours.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colours.border),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: TextStyle(
                color: colours.body,
                fontSize: 12,
                height: 1.55,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (strongText != null && strongText!.trim().isNotEmpty) ...[
              const TextSpan(text: '\n\n'),
              TextSpan(
                text: strongText!,
                style: TextStyle(
                  color: colours.title,
                  fontSize: 12,
                  height: 1.55,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PolicySheetColours {
  final Color sheetBg;
  final Color cardBg;
  final Color innerCardBg;
  final Color border;
  final Color innerBorder;
  final Color title;
  final Color body;
  final Color sectionLabel;
  final Color link;

  const _PolicySheetColours({
    required this.sheetBg,
    required this.cardBg,
    required this.innerCardBg,
    required this.border,
    required this.innerBorder,
    required this.title,
    required this.body,
    required this.sectionLabel,
    required this.link,
  });

  factory _PolicySheetColours.fromTheme(bool dark) {
    if (dark) {
      return const _PolicySheetColours(
        sheetBg: Color(0xFF171717),
        cardBg: Color(0xFF171717),
        innerCardBg: Color(0xFF101010),
        border: Color(0xFF343434),
        innerBorder: Color(0xFF2A2A2A),
        title: Colors.white,
        body: Color(0xFFD4D4D4),
        sectionLabel: Color(0xFFB5B5B5),
        link: Colors.white,
      );
    }

    return const _PolicySheetColours(
      sheetBg: Color(0xFFFFFFFF),
      cardBg: Color(0xFFF9FAFB),
      innerCardBg: Color(0xFFFFFFFF),
      border: Color(0xFFE5E7EB),
      innerBorder: Color(0xFFE5E7EB),
      title: Color(0xFF111827),
      body: Color(0xFF4B5563),
      sectionLabel: Color(0xFF6B7280),
      link: Color(0xFF111827),
    );
  }
}