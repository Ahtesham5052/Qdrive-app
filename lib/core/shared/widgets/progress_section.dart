// ==========================================
// PROGRESS SECTION
// Supports:
// 1. New config.layout row/column JSON format
// 2. Static progress from resolved props
// 3. Uploaded document progress from Riverpod
// 4. Old hardcoded fallback if config.layout is missing
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/upload_document_provider.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

/// A reusable JSON-driven progress section.
///
/// This widget supports two rendering modes:
///
/// 1. New layout-driven mode:
///    Uses `config.layout` and renders row/column/container/text
///    through [JsonLayoutRenderer].
///
/// 2. Legacy fallback mode:
///    Uses the old hardcoded progress layout when `config.layout`
///    is missing.
///
/// It also supports live uploaded document progress through Riverpod.
class ProgressSection extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  /// Creates a progress section from JSON data.
  const ProgressSection({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ========================================
    // Root classes
    // Example: ["mb-lg"]
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Theme from JSON
    // Example:
    // label, value, track, fill
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
    // label, value, progress, totalRequired
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ========================================
    // Computed progress values
    // Handles static progress and uploaded docs.
    // ========================================

    final progressData = _resolveProgressData(ref, props);

    // ========================================
    // New layout-driven rendering
    // ========================================

    if (layout.isNotEmpty) {
      return Container(
        margin: ElementSettings.margin(classes),
        child: _buildLayoutDrivenProgress(
          context: context,
          layout: layout,
          theme: theme,
          config: config,
          props: progressData,
        ),
      );
    }

    // ========================================
    // Fallback for old JSON without config.layout
    // ========================================

    return _legacyProgressSection(
      context: context,
      classes: classes,
      props: progressData,
      theme: theme,
    );
  }

  // ==========================================
  // Resolves progress values.
  //
  // If progressSourceKey == "documents", the progress
  // comes from uploadedDocumentsProvider.
  //
  // Otherwise, the progress comes from resolved props.
  // ==========================================

  Map<dynamic, dynamic> _resolveProgressData(
    WidgetRef ref,
    Map<dynamic, dynamic> props,
  ) {
    final uploadedDocuments = ref.watch(uploadedDocumentsProvider);

    final sourceKey = props['progressSourceKey']?.toString();

    final totalRequired = (props['totalRequired'] is num)
        ? (props['totalRequired'] as num).toInt()
        : 0;

    final uploadedCount = sourceKey == 'documents'
        ? uploadedDocuments.length
        : (props['uploadedCount'] is num)
        ? (props['uploadedCount'] as num).toInt()
        : 0;

    final progress = sourceKey == 'documents' && totalRequired > 0
        ? (uploadedCount / totalRequired).clamp(0.0, 1.0)
        : (props['progress'] is num)
        ? (props['progress'] as num).toDouble().clamp(0.0, 1.0)
        : 0.0;

    final valueText = sourceKey == 'documents' && totalRequired > 0
        ? '$uploadedCount/$totalRequired'
        : props['value']?.toString() ?? '';

    final labelText = props['label']?.toString() ?? '';

    final progressLabelText =
        props['progressLabel']?.toString() ??
        (sourceKey == 'documents' && totalRequired > 0 ? valueText : '');

    return {
      ...props,

      "label": labelText,
      "value": valueText,
      "progress": progress,
      "uploadedCount": uploadedCount,
      "totalRequired": totalRequired,

      "progressValue": valueText,
      "progressLabel": progressLabelText,
    };
  }

  // ==========================================
  // Builds progress section using config.layout.
  //
  // Important:
  // JsonLayoutRenderer can render normal row/column/text/container.
  // This widget intercepts progress track containers so the fill
  // width can still be controlled by `progress`.
  // ==========================================

  Widget _buildLayoutDrivenProgress({
    required BuildContext context,
    required List<Map<dynamic, dynamic>> layout,
    required Map<dynamic, dynamic> theme,
    required Map<dynamic, dynamic> config,
    required Map<dynamic, dynamic> props,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: layout.map((section) {
        return _ProgressLayoutNode(
          node: section,
          props: props,
          theme: theme,
          config: config,
        );
      }).toList(),
    );
  }

  // ==========================================
  // Legacy fallback.
  // Keeps old progress JSON working safely.
  // ==========================================

  Widget _legacyProgressSection({
    required BuildContext context,
    required List<String> classes,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
  }) {
    final progress = (props['progress'] is num)
        ? (props['progress'] as num).toDouble().clamp(0.0, 1.0)
        : 0.0;

    final valueText = props['value']?.toString() ?? '';

    final trackClasses = ElementSettings.classList(theme['track']);
    final fillClasses = ElementSettings.classList(theme['fill']);

    return Container(
      margin: ElementSettings.margin(classes),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  props['label']?.toString() ?? '',
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(theme['label']),
                  ),
                ),
              ),

              Text(
                valueText,
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['value']),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            height: 5,
            decoration: ElementSettings.decoration(context, trackClasses),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: ElementSettings.decoration(context, fillClasses),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PROGRESS LAYOUT NODE
// Small wrapper around JsonLayoutRenderer.
//
// It lets normal JSON layout render through
// JsonLayoutRenderer, but adds special handling
// for the progress bar fill.
// ==========================================

class _ProgressLayoutNode extends StatelessWidget {
  final Map<dynamic, dynamic> node;
  final Map<dynamic, dynamic> props;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;

  const _ProgressLayoutNode({
    required this.node,
    required this.props,
    required this.theme,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final type = node['type']?.toString();

    // ========================================
    // Special case:
    // If this is a track container and its child
    // has "progressKey", render a real progress bar.
    // ========================================

    if (type == 'container') {
      final child = node['child'];

      if (child is Map && child['progressKey'] != null) {
        return _buildProgressTrack(context, child);
      }
    }

    // ========================================
    // Recursive support for columns and rows
    // so nested progress containers can be found.
    // ========================================

    if (type == 'column') {
      return _buildColumn(context);
    }

    if (type == 'row') {
      return _buildRow(context);
    }

    // ========================================
    // Default JSON renderer support.
    // ========================================

    return JsonLayoutRenderer(
      node: node,
      data: props,
      locals: const {},
      theme: theme,
      config: config,
      currency: '',
    );
  }

  // ==========================================
  // Renders column while still allowing nested
  // progress bar detection.
  // ==========================================

  Widget _buildColumn(BuildContext context) {
    final children = List<Map<dynamic, dynamic>>.from(node['children'] ?? []);

    return Container(
      margin: ElementSettings.margin(
        ElementSettings.classList(node['classes']),
      ),
      child: Column(
        crossAxisAlignment: _crossAxis(node['crossAxis']),
        mainAxisAlignment: _mainAxis(node['mainAxis']),
        children: children.map((childNode) {
          return _ProgressLayoutNode(
            node: childNode,
            props: props,
            theme: theme,
            config: config,
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // Renders row while still allowing nested
  // progress bar detection.
  // ==========================================

  Widget _buildRow(BuildContext context) {
    final children = List<Map<dynamic, dynamic>>.from(node['children'] ?? []);

    return Container(
      margin: ElementSettings.margin(
        ElementSettings.classList(node['classes']),
      ),
      child: Row(
        crossAxisAlignment: _crossAxis(node['crossAxis']),
        mainAxisAlignment: _mainAxis(node['mainAxis']),
        children: children.map((childNode) {
          final child = _ProgressLayoutNode(
            node: childNode,
            props: props,
            theme: theme,
            config: config,
          );

          final flex = childNode['flex'];

          if (flex is int && flex > 0) {
            return Expanded(flex: flex, child: child);
          }

          return child;
        }).toList(),
      ),
    );
  }

  // ==========================================
  // Renders the actual progress track and fill.
  // ==========================================

  Widget _buildProgressTrack(
    BuildContext context,
    Map<dynamic, dynamic> fillNode,
  ) {
    final progressKey = fillNode['progressKey']?.toString() ?? 'progress';

    final progress = (props[progressKey] is num)
        ? (props[progressKey] as num).toDouble().clamp(0.0, 1.0)
        : 0.0;

    final trackThemeKey = node['themeKey'];
    final fillThemeKey = fillNode['themeKey'];

    final trackClasses = [
      ...ElementSettings.classList(theme[trackThemeKey]),
      ...ElementSettings.classList(node['classes']),
    ];

    final fillClasses = [
      ...ElementSettings.classList(theme[fillThemeKey]),
      ...ElementSettings.classList(fillNode['classes']),
    ];

    final height = _heightFromNode(node) ?? _heightFromNode(fillNode) ?? 5.0;

    return Container(
      width: double.infinity,
      height: height,
      margin: ElementSettings.margin(
        ElementSettings.classList(node['classes']),
      ),
      decoration: ElementSettings.decoration(context, trackClasses),
      clipBehavior: Clip.antiAlias,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          height: height,
          decoration: ElementSettings.decoration(context, fillClasses),
        ),
      ),
    );
  }

  // ==========================================
  // Reads height from a node.
  // Supports:
  // "height": 8
  // ==========================================

  double? _heightFromNode(Map<dynamic, dynamic> value) {
    final height = value['height'];

    if (height is num) {
      return height.toDouble();
    }

    return null;
  }

  // ==========================================
  // Converts JSON crossAxis to Flutter enum.
  // ==========================================

  CrossAxisAlignment _crossAxis(dynamic value) {
    switch (value) {
      case 'center':
        return CrossAxisAlignment.center;
      case 'end':
        return CrossAxisAlignment.end;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      case 'start':
      default:
        return CrossAxisAlignment.start;
    }
  }

  // ==========================================
  // Converts JSON mainAxis to Flutter enum.
  // ==========================================

  MainAxisAlignment _mainAxis(dynamic value) {
    switch (value) {
      case 'center':
        return MainAxisAlignment.center;
      case 'end':
        return MainAxisAlignment.end;
      case 'spaceBetween':
      case 'between':
        return MainAxisAlignment.spaceBetween;
      case 'spaceAround':
      case 'around':
        return MainAxisAlignment.spaceAround;
      case 'spaceEvenly':
      case 'evenly':
        return MainAxisAlignment.spaceEvenly;
      case 'start':
      default:
        return MainAxisAlignment.start;
    }
  }
}
