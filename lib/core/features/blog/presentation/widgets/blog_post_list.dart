// ==========================================
// BLOG POST LIST
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

class BlogPostList extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const BlogPostList({super.key, required this.data});

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
    // item, image, category, title, description, meta
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

    return _legacyBlogList(
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
    // so each blog item can still be wrapped
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
            return _BlogPostLayoutItem(
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
    // layout and render it once per blog item.
    // ========================================

    return Column(
      children: items.map((item) {
        return _BlogPostLayoutItem(
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
  // Keeps old blog JSON working safely.
  // ==========================================

  Widget _legacyBlogList({
    required BuildContext context,
    required List<String> classes,
    required List<Map<dynamic, dynamic>> items,
    required Map<dynamic, dynamic> theme,
  }) {
    return Container(
      margin: ElementSettings.margin(classes),
      child: Column(
        children: items.map((item) {
          return _LegacyBlogPostItem(item: item, theme: theme);
        }).toList(),
      ),
    );
  }
}

// ==========================================
// BLOG POST LAYOUT ITEM
// Renders one post using JsonLayoutRenderer
// ==========================================

class _BlogPostLayoutItem extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final String itemName;
  final List<Map<dynamic, dynamic>> layout;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;

  const _BlogPostLayoutItem({
    required this.item,
    required this.itemName,
    required this.layout,
    required this.theme,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _handleAction(context, item['action']);
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
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
        // Connect to your central navigation/action handler.
        return;

      default:
        return;
    }
  }
}

// ==========================================
// LEGACY BLOG POST ITEM
// Used only if config.layout is missing
// ==========================================

class _LegacyBlogPostItem extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final Map<dynamic, dynamic> theme;

  const _LegacyBlogPostItem({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    final itemClasses = ElementSettings.classList(theme['item']);

    final imageClasses = ElementSettings.classList(theme['image']);

    return Container(
      padding: ElementSettings.padding(itemClasses),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ElementSettings.borderColor(context, itemClasses),
          ),
        ),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: ElementSettings.radius(imageClasses),
              child: Image.network(
                item['image'] ?? '',
                width: 150,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 150,
                    height: 120,
                    color: ElementSettings.background(context, ['bg-muted']),
                    child: const Icon(Icons.image_not_supported_outlined),
                  );
                },
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ElementIcons.show(
                        context,
                        item['categoryIcon'],
                        size: 12,
                        color: ElementSettings.textColor(
                          context,
                          ElementSettings.classList(theme['categoryIcon']),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item['category'] ?? '',
                        style: ElementSettings.textStyle(
                          context,
                          ElementSettings.classList(theme['category']),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    item['title'] ?? '',
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['title']),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    item['description'] ?? '',
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['description']),
                    ),
                  ),

                  const SizedBox(height: 10),

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
