// ==========================================
// DETAIL GALLERY
// Supports:
// 1. New config.layout JSON structure
// 2. Image slider through JsonLayoutRenderer
// 3. Clickable gallery control buttons
// 4. Old fallback layout if config.layout is missing
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/shared/widgets/image_slider.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class DetailGallery extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const DetailGallery({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ========================================
    // Root sections
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Merge resolved props into renderer data
    // This allows JSON keys like:
    // images, currentImageIndex, backIcon, viewIcon
    // ========================================

    final renderData = {...Map<dynamic, dynamic>.from(data), ...props};

    // ========================================
    // Gallery height
    // Uses theme.imageSlider.classes height token
    // ========================================

    final imageSliderTheme = Map<dynamic, dynamic>.from(
      theme['imageSlider'] ?? {},
    );

    final imageClasses = ElementSettings.classList(imageSliderTheme['classes']);

    final galleryHeight = ElementSettings.height(context, imageClasses) ?? 300;

    // ========================================
    // New JSON-driven layout
    // ========================================

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    if (layout.isNotEmpty) {
      return Container(
        margin: ElementSettings.margin(classes),
        child: SizedBox(
          width: double.infinity,
          height: galleryHeight,
          child: _GalleryLayoutRenderer(
            layout: layout,
            data: renderData,
            theme: theme,
            config: config,
            onAction: (action) {
              _handleAction(context, action, fallback: () {});
            },
          ),
        ),
      );
    }

    // ========================================
    // Old fallback layout
    // ========================================

    return _legacyGallery(
      context: context,
      props: props,
      theme: theme,
      config: config,
      classes: classes,
      galleryHeight: galleryHeight,
    );
  }

  // ==========================================
  // Legacy fallback
  // Keeps older JSON working
  // ==========================================

  Widget _legacyGallery({
    required BuildContext context,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
    required Map<dynamic, dynamic> config,
    required List<String> classes,
    required double galleryHeight,
  }) {
    final imageSliderTheme = Map<dynamic, dynamic>.from(
      theme['imageSlider'] ?? {},
    );

    final imageSliderConfig = Map<dynamic, dynamic>.from(
      config['imageSlider'] ?? {},
    );

    final imageSliderData = {
      ...imageSliderTheme,
      ...imageSliderConfig,
      "images": props['images'] ?? [],
      "currentIndex": props['currentImageIndex'] ?? 0,
    };

    final controlsConfig = Map<dynamic, dynamic>.from(config['controls'] ?? {});

    final controlClasses = ElementSettings.classList(theme['control']);
    final controlIconClasses = ElementSettings.classList(theme['controlIcon']);

    return Container(
      margin: ElementSettings.margin(classes),
      child: SizedBox(
        width: double.infinity,
        height: galleryHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: ImageSlider(
                data: imageSliderData,
                fallbackHeight: galleryHeight,
              ),
            ),

            if (props['showBack'] == true)
              Positioned(
                top: 14,
                left: 14,
                child: _GalleryControlButton(
                  icon: props['backIcon'] ?? 'arrow_back',
                  classes: controlClasses,
                  iconClasses: controlIconClasses,
                  size: controlsConfig['size'],
                  iconSize: controlsConfig['iconSize'],
                  onTap: () {
                    _handleAction(
                      context,
                      props['backAction'],
                      fallback: () => Navigator.of(context).maybePop(),
                    );
                  },
                ),
              ),

            if (props['show3DView'] == true)
              Positioned(
                right: 14,
                bottom: 24,
                child: _GalleryControlButton(
                  icon: props['viewIcon'] ?? 'view_3d',
                  classes: controlClasses,
                  iconClasses: controlIconClasses,
                  size: controlsConfig['size'],
                  iconSize: controlsConfig['iconSize'],
                  onTap: () {
                    _handleAction(
                      context,
                      props['viewAction'],
                      fallback: () {},
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Lightweight action handling
  // Replace later with central ActionHandler
  // ==========================================

  void _handleAction(
    BuildContext context,
    dynamic action, {
    required VoidCallback fallback,
  }) {
    if (action is! Map) {
      fallback();
      return;
    }

    final type = action['type'];

    switch (type) {
      case 'go_back':
        Navigator.of(context).maybePop();
        return;

      case 'open_3d_view':
        // TODO:
        // Connect to central ActionHandler.
        fallback();
        return;

      default:
        fallback();
        return;
    }
  }
}

// ==========================================
// GALLERY LAYOUT RENDERER
// Small wrapper around JsonLayoutRenderer
// Adds gallery-only clickable control support
// ==========================================

class _GalleryLayoutRenderer extends StatelessWidget {
  final List<Map<dynamic, dynamic>> layout;
  final Map<dynamic, dynamic> data;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;
  final void Function(dynamic action) onAction;

  const _GalleryLayoutRenderer({
    required this.layout,
    required this.data,
    required this.theme,
    required this.config,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: layout.map((node) {
        return _GalleryNodeRenderer(
          node: node,
          data: data,
          theme: theme,
          config: config,
          onAction: onAction,
        );
      }).toList(),
    );
  }
}

// ==========================================
// GALLERY NODE RENDERER
// Supports gallery-specific nodes:
// - stack
// - positioned
// - gallery_control_button
// Everything else goes to JsonLayoutRenderer
// ==========================================

class _GalleryNodeRenderer extends StatelessWidget {
  final Map<dynamic, dynamic> node;
  final Map<dynamic, dynamic> data;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;
  final void Function(dynamic action) onAction;

  const _GalleryNodeRenderer({
    required this.node,
    required this.data,
    required this.theme,
    required this.config,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final type = node['type'];

    if (!_isVisible()) {
      return const SizedBox.shrink();
    }

    if (type == 'stack') {
      return _stack(context);
    }

    if (type == 'positioned') {
      return _positioned(context);
    }

    if (type == 'gallery_control_button') {
      return _galleryControlButton(context);
    }

    return JsonLayoutRenderer(
      node: node,
      data: data,
      theme: theme,
      config: config,
      currency: data['currency']?.toString() ?? '',
    );
  }

  // ========================================
  // Stack support
  // ========================================

  Widget _stack(BuildContext context) {
    final children = List<Map<dynamic, dynamic>>.from(node['children'] ?? []);

    return Stack(
      children: children.map((childNode) {
        return _GalleryNodeRenderer(
          node: childNode,
          data: data,
          theme: theme,
          config: config,
          onAction: onAction,
        );
      }).toList(),
    );
  }

  // ========================================
  // Positioned support
  // Same parent-data safe approach as main renderer
  // ========================================

  Widget _positioned(BuildContext context) {
    final classes = ElementSettings.classList(node['classes']);

    final childNode = Map<dynamic, dynamic>.from(node['child'] ?? {});

    return Positioned.fill(
      child: Container(
        margin: ElementSettings.margin(classes),
        padding: ElementSettings.padding(classes),
        child: Align(
          alignment: _alignment(node['alignment']),
          child: _GalleryNodeRenderer(
            node: childNode,
            data: data,
            theme: theme,
            config: config,
            onAction: onAction,
          ),
        ),
      ),
    );
  }

  // ========================================
  // Clickable gallery control button
  // ========================================

  Widget _galleryControlButton(BuildContext context) {
    final controlsConfig = Map<dynamic, dynamic>.from(config['controls'] ?? {});

    final controlClasses = ElementSettings.classList(
      theme[node['themeKey'] ?? 'control'],
    );

    final controlIconClasses = ElementSettings.classList(
      theme[node['iconThemeKey'] ?? 'controlIcon'],
    );

    final icon =
        _read(node['iconKey']?.toString() ?? '') ?? node['icon'] ?? 'help';

    final action = _read(node['actionKey']?.toString() ?? '') ?? node['action'];

    return _GalleryControlButton(
      icon: icon,
      classes: controlClasses,
      iconClasses: controlIconClasses,
      size: node['size'] ?? controlsConfig['size'],
      iconSize: node['iconSize'] ?? controlsConfig['iconSize'],
      onTap: () => onAction(action),
    );
  }

  // ========================================
  // Visibility support
  // Example: showBack == true
  // ========================================

  bool _isVisible() {
    final visibleWhen = node['visibleWhen'];

    if (visibleWhen == null) return true;

    if (visibleWhen is bool) return visibleWhen;

    if (visibleWhen is String && visibleWhen.contains('== true')) {
      final path = visibleWhen.replaceAll('== true', '').trim();
      return _read(path) == true;
    }

    if (visibleWhen is String && visibleWhen.contains('!= null')) {
      final path = visibleWhen.replaceAll('!= null', '').trim();
      return _read(path) != null;
    }

    return true;
  }

  // ========================================
  // Deep reader
  // ========================================

  dynamic _read(String path) {
    if (path.isEmpty) return null;

    dynamic current = data;

    for (final key in path.split('.')) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current;
  }

  // ========================================
  // Alignment helper
  // ========================================

  Alignment _alignment(dynamic value) {
    switch (value) {
      case 'topRight':
        return Alignment.topRight;
      case 'topLeft':
        return Alignment.topLeft;
      case 'bottomRight':
        return Alignment.bottomRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'center':
        return Alignment.center;
      default:
        return Alignment.topLeft;
    }
  }
}

// ==========================================
// GALLERY CONTROL BUTTON
// Reusable circular icon control
// ==========================================

class _GalleryControlButton extends StatelessWidget {
  final dynamic icon;
  final List<String> classes;
  final List<String> iconClasses;
  final dynamic size;
  final dynamic iconSize;
  final VoidCallback onTap;

  const _GalleryControlButton({
    required this.icon,
    required this.classes,
    required this.iconClasses,
    required this.size,
    required this.iconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = ElementSettings.size(size);
    final resolvedIconSize = ElementSettings.iconSize(iconSize);

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: ElementSettings.decoration(context, classes),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: onTap,
        icon: ElementIcons.show(
          context,
          icon,
          size: resolvedIconSize,
          color: ElementSettings.textColor(context, iconClasses),
        ),
      ),
    );
  }
}
