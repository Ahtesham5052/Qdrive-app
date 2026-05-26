import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';

class TagChip extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const TagChip({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final props = data['props'] ?? {};
    final theme = data['theme'] ?? {};
    final classes = ElementSettings.classList(data['classes']);

    final containerClasses = ElementSettings.classList(theme['container']);
    final align = props['align']?.toString() ?? 'start';

    final chip = Container(
      padding: ElementSettings.padding(containerClasses),
      decoration: ElementSettings.decoration(context, containerClasses),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if ((props['icon'] ?? '').toString().isNotEmpty) ...[
            ElementIcons.show(
              context,
              props['icon'],
              size: 12,
              color: ElementSettings.textColor(
                context,
                ElementSettings.classList(theme['icon']),
              ),
            ),

            const SizedBox(width: 6),
          ],
          Text(
            props['label'] ?? '',
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['label']),
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      margin: ElementSettings.margin(classes),
      alignment: align == 'center' ? Alignment.center : Alignment.centerLeft,
      child: chip,
    );
  }
}
