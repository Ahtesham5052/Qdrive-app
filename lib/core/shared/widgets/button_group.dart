// ==========================================
// BUTTON GROUP
// Supports:
// 1. New config.layout row/column JSON format
// 2. for_each based button JSON layout
// 3. Button-level actions injected by JsonResolver
// 4. Old hardcoded fallback if config.layout is missing
// ==========================================

import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class ButtonGroup extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const ButtonGroup({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ========================================
    // Root classes
    // Example: ["mb-md"]
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Theme from JSON
    // Example:
    // iconButton, iconButtonIcon,
    // primaryButton, primaryLabel, primaryIcon,
    // secondaryButton, secondaryLabel, secondaryIcon
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
    // align, buttons
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    final buttons = List<Map<dynamic, dynamic>>.from(props['buttons'] ?? []);

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ========================================
    // New layout-driven rendering
    // ========================================

    if (layout.isNotEmpty) {
      return Container(
        width: double.infinity,
        margin: ElementSettings.margin(classes),
        child: _buildLayoutDrivenButtonGroup(
          context: context,
          buttons: buttons,
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

    return _legacyButtonGroup(
      context: context,
      classes: classes,
      props: props,
      buttons: buttons,
      theme: theme,
    );
  }

  // ==========================================
  // Builds button group using config.layout
  //
  // Supports both:
  //
  // A) config.layout contains a direct for_each node:
  //    [
  //      {
  //        "type": "for_each",
  //        "itemName": "button",
  //        "child": {...}
  //      }
  //    ]
  //
  // B) config.layout contains row/column layout:
  //    [
  //      {
  //        "type": "row",
  //        "children": [...]
  //      }
  //    ]
  //
  // If the layout starts with for_each, each button is wrapped
  // with a tappable GestureDetector. If the layout is a normal
  // row/column, JsonLayoutRenderer handles the structure directly.
  // ==========================================

  Widget _buildLayoutDrivenButtonGroup({
    required BuildContext context,
    required List<Map<dynamic, dynamic>> buttons,
    required List<Map<dynamic, dynamic>> layout,
    required Map<dynamic, dynamic> theme,
    required Map<dynamic, dynamic> config,
    required Map<dynamic, dynamic> props,
  }) {
    final firstNode = layout.isNotEmpty ? layout.first : null;

    // ========================================
    // Direct for_each support
    // Useful when the button group itself is
    // only a repeating list of buttons.
    // ========================================

    if (firstNode != null && firstNode['type'] == 'for_each') {
      final itemName = firstNode['itemName']?.toString() ?? 'button';

      final childNode = Map<dynamic, dynamic>.from(firstNode['child'] ?? {});

      final forEachClasses = ElementSettings.classList(firstNode['classes']);

      final align = props['align']?.toString() ?? 'start';

      return Container(
        margin: ElementSettings.margin(forEachClasses),
        padding: ElementSettings.padding(forEachClasses),
        child: Wrap(
          alignment: _wrapAlignment(align),
          spacing: 12,
          runSpacing: 12,
          children: buttons.map((button) {
            return _ButtonLayoutItem(
              button: button,
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
    // General row/column config layout support
    // Example:
    // config.layout = [
    //   {
    //     "type": "row",
    //     "children": [
    //       {
    //         "type": "for_each",
    //         "itemsKey": "buttons",
    //         "itemName": "button",
    //         "child": {...}
    //       }
    //     ]
    //   }
    // ]
    // ========================================

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: layout.map((section) {
        return JsonLayoutRenderer(
          node: section,

          // Keep full props as main data.
          data: props,

          // Also expose buttons if renderer needs locals.
          locals: {"buttons": buttons},

          theme: theme,
          config: config,
          currency: '',
        );
      }).toList(),
    );
  }

  // ==========================================
  // Legacy fallback
  // Keeps old button group JSON working safely.
  // ==========================================

  Widget _legacyButtonGroup({
    required BuildContext context,
    required List<String> classes,
    required Map<dynamic, dynamic> props,
    required List<Map<dynamic, dynamic>> buttons,
    required Map<dynamic, dynamic> theme,
  }) {
    final align = props['align']?.toString() ?? 'start';

    return Container(
      width: double.infinity,
      margin: ElementSettings.margin(classes),
      child: Wrap(
        alignment: _wrapAlignment(align),
        spacing: 12,
        runSpacing: 12,
        children: buttons.map((button) {
          return _ActionButton(button: button, theme: theme);
        }).toList(),
      ),
    );
  }

  // ==========================================
  // Converts JSON align value to WrapAlignment.
  // ==========================================

  WrapAlignment _wrapAlignment(String align) {
    switch (align) {
      case 'center':
        return WrapAlignment.center;
      case 'end':
        return WrapAlignment.end;
      case 'start':
      default:
        return WrapAlignment.start;
    }
  }
}

// ==========================================
// BUTTON LAYOUT ITEM
// Renders one button using JsonLayoutRenderer
// Used only when config.layout starts with for_each.
// ==========================================

class _ButtonLayoutItem extends StatelessWidget {
  final Map<dynamic, dynamic> button;
  final String itemName;
  final List<Map<dynamic, dynamic>> layout;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;

  const _ButtonLayoutItem({
    required this.button,
    required this.itemName,
    required this.layout,
    required this.theme,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _handleAction(context, button);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: layout.map((section) {
          return JsonLayoutRenderer(
            node: section,

            // Keep button as main data.
            data: button,

            // Also expose it as button.icon, button.label, etc.
            locals: {itemName: button},

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

  void _handleAction(BuildContext context, Map<dynamic, dynamic> button) {
    final onTap = button['onTap'];

    if (onTap is VoidCallback) {
      onTap();
      return;
    }

    final action = button['action'];
    final actionRef = button['actionRef'];

    if (action != null || actionRef != null) {
      // TODO:
      // Connect to your central ActionHandler.
      return;
    }
  }
}

// ==========================================
// LEGACY ACTION BUTTON
// Used only if config.layout is missing.
// ==========================================

class _ActionButton extends StatelessWidget {
  final Map<dynamic, dynamic> button;
  final Map<dynamic, dynamic> theme;

  const _ActionButton({required this.button, required this.theme});

  @override
  Widget build(BuildContext context) {
    // ========================================
    // Button variant
    // Supported:
    // primary, secondary, icon
    // ========================================

    final variant = button['variant']?.toString() ?? 'secondary';

    final isPrimary = variant == 'primary';
    final isIconOnly = variant == 'icon';

    // ========================================
    // Theme class resolution
    // ========================================

    final buttonClasses = ElementSettings.classList(
      isIconOnly
          ? theme['iconButton']
          : isPrimary
          ? theme['primaryButton']
          : theme['secondaryButton'],
    );

    final labelClasses = ElementSettings.classList(
      isPrimary ? theme['primaryLabel'] : theme['secondaryLabel'],
    );

    final iconClasses = ElementSettings.classList(
      isIconOnly
          ? theme['iconButtonIcon']
          : isPrimary
          ? theme['primaryIcon']
          : theme['secondaryIcon'],
    );

    // ========================================
    // Button content
    // ========================================

    final icon = button['icon']?.toString() ?? '';
    final label = button['label']?.toString() ?? '';
    final trailingIcon = button['trailingIcon']?.toString() ?? '';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _handleAction(context, button);
      },
      child: Container(
        width: isIconOnly ? 44 : null,
        height: isIconOnly ? 44 : null,
        padding: isIconOnly
            ? EdgeInsets.zero
            : ElementSettings.padding(buttonClasses),
        decoration: ElementSettings.decoration(context, buttonClasses),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon.isNotEmpty)
              ElementIcons.show(
                context,
                icon,
                size: isIconOnly ? 20 : 16,
                color: ElementSettings.textColor(context, iconClasses),
              ),

            if (label.isNotEmpty) ...[
              if (icon.isNotEmpty) const SizedBox(width: 8),
              Text(
                label,
                style: ElementSettings.textStyle(context, labelClasses),
              ),
            ],

            if (trailingIcon.isNotEmpty) ...[
              const SizedBox(width: 8),
              ElementIcons.show(
                context,
                trailingIcon,
                size: 16,
                color: ElementSettings.textColor(context, iconClasses),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ========================================
  // Placeholder action handling
  // Replace later with central ActionHandler.
  // ========================================

  void _handleAction(BuildContext context, Map<dynamic, dynamic> button) {
    final onTap = button['onTap'];

    if (onTap is VoidCallback) {
      onTap();
      return;
    }

    final action = button['action'];
    final actionRef = button['actionRef'];

    if (action != null || actionRef != null) {
      // TODO:
      // Connect to your central ActionHandler.
      return;
    }
  }
}
