// ==========================================
// TEXT BLOCK
// Supports both:
// 1. New config.layout JSON renderer format
// 2. Old hardcoded text block fallback
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class TextBlock extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const TextBlock({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ========================================
    // Root classes
    // Example: ["my-md"], ["mb-lg"]
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Theme from JSON
    // Example:
    // iconBox, icon, eyebrow, eyebrowIcon,
    // title, subtitle
    // ========================================

    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});

    // ========================================
    // Config from JSON
    // New architecture expects:
    // config.layout = [...]
    // ========================================

    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});

    // ========================================
    // Resolved props from JsonResolver
    // Example:
    // icon, eyebrow, eyebrowIcon, title,
    // subtitle, align, maxWidth
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    // ========================================
    // Alignment settings
    // Keeps old align/maxWidth behaviour working
    // even when layout is JSON-driven.
    // ========================================

    final align = props['align']?.toString() ?? 'start';

    final maxWidth = props['maxWidth'] is num
        ? (props['maxWidth'] as num).toDouble()
        : double.infinity;

    final containerAlignment = align == 'center'
        ? Alignment.center
        : Alignment.centerLeft;

    final crossAxisAlignment = align == 'center'
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    // ========================================
    // New JSON layout
    // ========================================

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    if (layout.isNotEmpty) {
      final renderData = {...Map<dynamic, dynamic>.from(data), ...props};

      return Container(
        width: double.infinity,
        margin: ElementSettings.margin(classes),
        alignment: containerAlignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
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
        ),
      );
    }

    // ========================================
    // Fallback for old JSON without config.layout
    // ========================================

    return _legacyTextBlock(
      context: context,
      classes: classes,
      props: props,
      theme: theme,
      align: align,
      maxWidth: maxWidth,
    );
  }

  // ==========================================
  // OLD TEXT BLOCK FALLBACK
  // Keeps old screens working safely.
  // ==========================================

  Widget _legacyTextBlock({
    required BuildContext context,
    required List<String> classes,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
    required String align,
    required double maxWidth,
  }) {
    final hasIcon = (props['icon'] ?? '').toString().isNotEmpty;

    final hasEyebrowIcon = (props['eyebrowIcon'] ?? '').toString().isNotEmpty;

    final eyebrow = (props['eyebrow'] ?? '').toString();

    final title = (props['title'] ?? '').toString();

    final subtitle = (props['subtitle'] ?? '').toString();

    final textAlign = align == 'center' ? TextAlign.center : TextAlign.start;

    final crossAxisAlignment = align == 'center'
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    final containerAlignment = align == 'center'
        ? Alignment.center
        : Alignment.centerLeft;

    final iconBoxClasses = ElementSettings.classList(theme['iconBox']);

    final iconClasses = ElementSettings.classList(theme['icon']);

    final eyebrowClasses = ElementSettings.classList(theme['eyebrow']);

    final eyebrowIconClasses = ElementSettings.classList(theme['eyebrowIcon']);

    return Container(
      width: double.infinity,
      margin: ElementSettings.margin(classes),
      alignment: containerAlignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            // ================================
            // Main optional top icon
            // ================================
            if (hasIcon) ...[
              Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: ElementSettings.decoration(context, iconBoxClasses),
                child: ElementIcons.show(
                  context,
                  props['icon'],
                  size: 34,
                  color: ElementSettings.textColor(context, iconClasses),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // ================================
            // Eyebrow row
            // Optional icon + eyebrow text
            // ================================
            if (eyebrow.isNotEmpty) ...[
              Row(
                mainAxisSize: align == 'center'
                    ? MainAxisSize.min
                    : MainAxisSize.max,
                mainAxisAlignment: align == 'center'
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  if (hasEyebrowIcon) ...[
                    ElementIcons.show(
                      context,
                      props['eyebrowIcon'],
                      size: 14,
                      color: ElementSettings.textColor(
                        context,
                        eyebrowIconClasses.isNotEmpty
                            ? eyebrowIconClasses
                            : eyebrowClasses,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],

                  Flexible(
                    child: Text(
                      eyebrow,
                      textAlign: textAlign,
                      style: ElementSettings.textStyle(context, eyebrowClasses),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // ================================
            // Main title
            // ================================
            if (title.isNotEmpty)
              Text(
                title,
                textAlign: textAlign,
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['title']),
                ),
              ),

            // ================================
            // Optional subtitle
            // ================================
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                subtitle,
                textAlign: textAlign,
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['subtitle']),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
