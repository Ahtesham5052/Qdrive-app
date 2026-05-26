import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:flutter/material.dart';

class ChangeTripNotice extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  const ChangeTripNotice({super.key, required this.data});

  @override
  State<ChangeTripNotice> createState() => _ChangeTripNoticeState();
}

class _ChangeTripNoticeState extends State<ChangeTripNotice>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  bool dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (dismissed) return const SizedBox.shrink();

    final props = Map<dynamic, dynamic>.from(widget.data['props'] ?? {});

    final icon = props['icon']?.toString() ?? 'swap';
    final title = props['title']?.toString() ?? 'Change trip';
    final bookingText = props['bookingText']?.toString() ?? '';
    final paidText = props['paidText']?.toString() ?? '';
    final showLabel = props['showLabel']?.toString() ?? 'How this works';
    final hideLabel = props['hideLabel']?.toString() ?? 'Hide details';
    final detailText = props['detailText']?.toString() ?? '';
    final dismissible = props['dismissible'] != false;

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF111A32),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF21498F), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElementIcons.show(
                  context,
                  icon,
                  size: 16,
                  color: const Color(0xFF8DB8FF),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Wrap(
                    
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.35,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (bookingText.isNotEmpty)
                        Text(
                          ' · $bookingText',
                          style: const TextStyle(
                            color: Color(0xFF91C4FF),
                            fontSize: 12,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (paidText.isNotEmpty)
                        Text(
                          ' · Paid $paidText',
                          style: const TextStyle(
                            color: Color(0xFF91C4FF),
                            fontSize: 12,
                            height: 1.35,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    ],
                  ),
                ),

                if (dismissible)
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      setState(() {
                        dismissed = true;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.close_rounded,
                        color: Color(0xFFC6D8FF),
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),

            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  expanded ? hideLabel : showLabel,
                  style: const TextStyle(
                    color: Color(0xFF91C4FF),
                    fontSize: 12,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor:   Color(0xFF91C4FF),
                  
                  ),
                ),
              ),
            ),

            if (expanded && detailText.isNotEmpty) ...[
              const SizedBox(height: 10),
              Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
             
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color(0xFF2E5BA8),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 32.0),
             
                child: Text(
                  detailText,
                  style: const TextStyle(
                    color:  Color(0xFF91C4FF),
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
