// ==========================================
// AI SEARCH PROMPT
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class AiSearchPrompt extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const AiSearchPrompt({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ========================================
    // Root utility classes
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Theme
    // ========================================

    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});

    // ========================================
    // Config
    // ========================================

    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});

    // ========================================
    // Merge widget + props
    // ========================================

    final renderData = {
      ...Map<dynamic, dynamic>.from(data),

      ...Map<dynamic, dynamic>.from(data['props'] ?? {}),
    };

    // ========================================
    // Shared layout
    // ========================================

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ========================================
    // Thin render shell only
    // ========================================

    return Container(
      margin: ElementSettings.margin(classes),

      padding: ElementSettings.padding(classes),

      decoration: ElementSettings.decoration(context, classes),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: layout.map((section) {
          return JsonLayoutRenderer(
            node: section,

            data: renderData,

            theme: theme,

            config: config,

            currency: '',
          );
        }).toList(),
      ),
    );
  }
}
