import 'package:flutter/material.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';

class RadioDot extends StatelessWidget {
  final bool selected;
  final List<String> classes;

  const RadioDot({required this.selected, required this.classes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ElementSettings.borderColor(context, classes),
          width: 2,
        ),
      ),
      child: selected
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ElementSettings.borderColor(context, classes),
              ),
            )
          : null,
    );
  }
}
