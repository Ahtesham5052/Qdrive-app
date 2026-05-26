// ==========================================
// BLOG ARTICLE
// Supports:
// 1. New config.layout row/column JSON format
// 2. for_each paragraph body JSON layout
// 3. Back action injected by JsonResolver
// 4. Old hardcoded fallback if config.layout is missing
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class BlogArticle extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const BlogArticle({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ========================================
    // Root classes
    // Example: ["mb-2xl"]
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Theme from JSON
    // Example:
    // back, backIcon, category, categoryIcon,
    // title, meta, image, body
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
    // backLabel, category, title, meta, image, body
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ========================================
    // New layout-driven rendering
    // ========================================

    if (layout.isNotEmpty) {
      return Container(
        margin: ElementSettings.margin(classes),
        child: _buildLayoutDrivenArticle(
          context: context,
          props: props,
          layout: layout,
          theme: theme,
          config: config,
        ),
      );
    }

    // ========================================
    // Fallback for old JSON without config.layout
    // ========================================

    return _legacyArticle(
      context: context,
      classes: classes,
      props: props,
      theme: theme,
    );
  }

  // ==========================================
  // Builds article using config.layout
  // ==========================================

  Widget _buildLayoutDrivenArticle({
    required BuildContext context,
    required Map<dynamic, dynamic> props,
    required List<Map<dynamic, dynamic>> layout,
    required Map<dynamic, dynamic> theme,
    required Map<dynamic, dynamic> config,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: layout.map((section) {
        return JsonLayoutRenderer(
          node: section,

          // Keep article props as main data.
          data: props,

          // Also expose values as article.title, article.body, etc.
          locals: {"article": props},

          theme: theme,
          config: config,
          currency: '',
        );
      }).toList(),
    );
  }

  // ==========================================
  // Legacy fallback
  // Keeps old article JSON working safely.
  // ==========================================

  Widget _legacyArticle({
    required BuildContext context,
    required List<String> classes,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
  }) {
    final body = List<String>.from(props['body'] ?? []);

    final imageClasses = ElementSettings.classList(theme['image']);

    return Container(
      margin: ElementSettings.margin(classes),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              _handleAction(context, props['backAction'] ?? props['action']);
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElementIcons.show(
                  context,
                  'arrow_back',
                  size: 16,
                  color: ElementSettings.textColor(
                    context,
                    ElementSettings.classList(theme['backIcon']),
                  ),
                ),

                const SizedBox(width: 6),

                Text(
                  props['backLabel'] ?? '',
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(theme['back']),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              ElementIcons.show(
                context,
                props['categoryIcon'],
                size: 16,
                color: ElementSettings.textColor(
                  context,
                  ElementSettings.classList(theme['categoryIcon']),
                ),
              ),

              const SizedBox(width: 8),

              Text(
                props['category'] ?? '',
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['category']),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            props['title'] ?? '',
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['title']),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            props['meta'] ?? '',
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['meta']),
            ),
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: imageClasses.isEmpty
                ? BorderRadius.circular(18)
                : ElementSettings.radius(imageClasses),
            child: Image.network(
              props['image'] ?? '',
              width:
                  ElementSettings.width(context, imageClasses) ??
                  double.infinity,
              height: ElementSettings.height(context, imageClasses) ?? 230,
              fit: ElementSettings.boxFit(imageClasses),
              errorBuilder: (_, __, ___) {
                return Container(
                  width: double.infinity,
                  height: ElementSettings.height(context, imageClasses) ?? 230,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          ...body.map((paragraph) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                paragraph,
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['body']),
                ).copyWith(height: 1.65),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ========================================
  // Placeholder action handling
  // Replace later with central ActionHandler.
  // ========================================

  void _handleAction(BuildContext context, dynamic action) {
    if (action is! Map) return;

    final type = action['type'];

    switch (type) {
      case 'navigate':
        // TODO:
        // Connect this to your central navigation/action handler.
        return;

      default:
        return;
    }
  }
}
