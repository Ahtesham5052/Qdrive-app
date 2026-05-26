// ==========================================
// RELATED POST LIST
// Supports:
// 1. New config.layout row/column JSON format
// 2. for_each based JSON layout
// 3. Item-level actions injected by JsonResolver
// 4. Old hardcoded fallback if config.layout is missing
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class RelatedPostList extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const RelatedPostList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ========================================
    // Root classes
    // Example: ["mb-xl"]
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Theme from JSON
    // Example:
    // card, image, category, title, meta
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
    // items
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    final items = List<Map<dynamic, dynamic>>.from(props['items'] ?? []);

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ========================================
    // New layout-driven rendering
    // ========================================

    if (layout.isNotEmpty) {
      return Container(
        margin: ElementSettings.margin(classes),
        child: _buildLayoutDrivenList(
          context: context,
          items: items,
          layout: layout,
          theme: theme,
          config: config,
          props: props,
        ),
      );
    }

    // ========================================
    // Fallback for old JSON without config.layout
    // ========================================

    return _legacyRelatedList(
      context: context,
      classes: classes,
      items: items,
      theme: theme,
    );
  }

  // ==========================================
  // Builds list using config.layout
  //
  // Supports both:
  //
  // A) config.layout contains a for_each node:
  //    [
  //      {
  //        "type": "for_each",
  //        "itemName": "post",
  //        "child": {...}
  //      }
  //    ]
  //
  // B) config.layout is already item-level:
  //    [
  //      {"type": "container", ...}
  //    ]
  // ==========================================

  Widget _buildLayoutDrivenList({
    required BuildContext context,
    required List<Map<dynamic, dynamic>> items,
    required List<Map<dynamic, dynamic>> layout,
    required Map<dynamic, dynamic> theme,
    required Map<dynamic, dynamic> config,
    required Map<dynamic, dynamic> props,
  }) {
    final firstNode = layout.isNotEmpty ? layout.first : null;

    // ========================================
    // If JSON uses for_each, extract its child
    // so each related post can still be wrapped
    // in an InkWell.
    // ========================================

    if (firstNode != null && firstNode['type'] == 'for_each') {
      final itemName = firstNode['itemName']?.toString() ?? 'post';

      final childNode = Map<dynamic, dynamic>.from(firstNode['child'] ?? {});

      final forEachClasses = ElementSettings.classList(firstNode['classes']);

      return Container(
        margin: ElementSettings.margin(forEachClasses),
        padding: ElementSettings.padding(forEachClasses),
        child: Column(
          children: items.map((item) {
            return _RelatedPostLayoutItem(
              item: item,
              itemName: itemName,
              layout: [childNode],
              theme: theme,
              config: config,
            );
          }).toList(),
        ),
      );
    }

    // ========================================
    // Otherwise treat config.layout as item-level
    // layout and render it once per related post.
    // ========================================

    return Column(
      children: items.map((item) {
        return _RelatedPostLayoutItem(
          item: item,
          itemName: 'post',
          layout: layout,
          theme: theme,
          config: config,
        );
      }).toList(),
    );
  }

  // ==========================================
  // Legacy fallback
  // Keeps old related post JSON working safely.
  // ==========================================

  Widget _legacyRelatedList({
    required BuildContext context,
    required List<String> classes,
    required List<Map<dynamic, dynamic>> items,
    required Map<dynamic, dynamic> theme,
  }) {
    return Container(
      margin: ElementSettings.margin(classes),
      child: Column(
        children: items.map((item) {
          return _LegacyRelatedPostItem(item: item, theme: theme);
        }).toList(),
      ),
    );
  }
}

// ==========================================
// RELATED POST LAYOUT ITEM
// Renders one related post using JsonLayoutRenderer
// ==========================================

class _RelatedPostLayoutItem extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final String itemName;
  final List<Map<dynamic, dynamic>> layout;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;

  const _RelatedPostLayoutItem({
    required this.item,
    required this.itemName,
    required this.layout,
    required this.theme,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: layout.map((section) {
        return JsonLayoutRenderer(
          node: section,
    
          // Keep item as main data.
          data: item,
    
          // Also expose it as post.image, post.title, etc.
          locals: {itemName: item},
    
          theme: theme,
          config: config,
          currency: '',
        );
      }).toList(),
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
        // Connect to your central navigation/action handler.
        return;

      default:
        return;
    }
  }
}

// ==========================================
// LEGACY RELATED POST ITEM
// Used only if config.layout is missing
// ==========================================

class _LegacyRelatedPostItem extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final Map<dynamic, dynamic> theme;

  const _LegacyRelatedPostItem({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    final cardClasses = ElementSettings.classList(theme['card']);
    final imageClasses = ElementSettings.classList(theme['image']);

    return Container(
      margin: ElementSettings.margin(cardClasses),
      padding: ElementSettings.padding(cardClasses),
      decoration: ElementSettings.decoration(context, cardClasses),
      child: InkWell(
        onTap: () {},
        borderRadius: ElementSettings.radius(
          cardClasses,
        ).resolve(Directionality.of(context)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: ElementSettings.radius(
                imageClasses,
              ).resolve(Directionality.of(context)),
              child: Image.network(
                item['image'] ?? '',
                width: ElementSettings.width(context, imageClasses) ?? 86,
                height: ElementSettings.height(context, imageClasses) ?? 74,
                fit: ElementSettings.boxFit(imageClasses),
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: ElementSettings.width(context, imageClasses) ?? 86,
                    height: ElementSettings.height(context, imageClasses) ?? 74,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_not_supported_outlined),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ElementIcons.show(
                        context,
                        item['categoryIcon'],
                        size: 13,
                        color: ElementSettings.textColor(
                          context,
                          ElementSettings.classList(theme['categoryIcon']),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          item['category'] ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: ElementSettings.textStyle(
                            context,
                            ElementSettings.classList(theme['category']),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    item['title'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['title']),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    item['meta'] ?? '',
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['meta']),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
