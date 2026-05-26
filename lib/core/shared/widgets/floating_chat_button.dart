import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/engine/screen/screen_builder.dart';
import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/mock/ai_chat.dart';
import 'package:flutter/material.dart';

class FloatingActionButtonElement extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const FloatingActionButtonElement({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final classes = ElementSettings.classList(data['classes']);
    final iconClasses = ElementSettings.classList(theme['icon']);

    return Container(
      width: 58,
      height: 58,
      decoration: ElementSettings.decoration(context, classes),
      child: IconButton(
        padding: EdgeInsets.zero,
        splashRadius: 28,

        // Opens AI Concierge screen from JSON.
        onPressed: () {
        final action = props['action'] ?? {};
          if (action == null) {
            return;
          }

         ActionHandler.handle(context, action);
        },

        icon: ElementIcons.show(
          context,
          props['icon'],
          size: 24,
          color: ElementSettings.textColor(context, iconClasses),
        ),
      ),
    );
  }
}
