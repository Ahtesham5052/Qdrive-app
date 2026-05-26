// ==========================================
// DOCUMENT UPLOAD CARD
// Supports:
// 1. New config.layout row/column JSON format
// 2. Upload from gallery
// 3. Take photo from camera
// 4. Uploaded success state
// 5. Riverpod uploaded document progress state
// 6. Old hardcoded fallback if config.layout is missing
// 7. Dashed border support for upload boxes
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/engine/style/dashed_border.dart';
import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/upload_document_provider.dart';

class DocumentUploadCard extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const DocumentUploadCard({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classes = ElementSettings.classList(data['classes']);
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    final documentType =
        props['documentType']?.toString() ?? data['id']?.toString() ?? '';

    final uploadedDocs = ref.watch(uploadedDocumentsProvider);
    final uploadedPath = uploadedDocs[documentType];

    final isUploaded = uploadedPath != null && uploadedPath.isNotEmpty;

    Future<void> pickDocument(ImageSource source) async {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
      );

      if (picked == null) return;

      // 1. Save uploaded file immediately.
      ref.read(uploadedDocumentsProvider.notifier).state = {
        ...ref.read(uploadedDocumentsProvider),
        documentType: picked.path,
      };

      // 2. Start AI validation state.
      ref.read(validatingDocumentsProvider.notifier).state = {
        ...ref.read(validatingDocumentsProvider),
        documentType: true,
      };

      ref.read(validatedDocumentsProvider.notifier).state = {
        ...ref.read(validatedDocumentsProvider),
        documentType: false,
      };

      // 3. Demo delay for AI validation.
      await Future.delayed(const Duration(milliseconds: 1800));

      // 4. Finish validation.
      ref.read(validatingDocumentsProvider.notifier).state = {
        ...ref.read(validatingDocumentsProvider),
        documentType: false,
      };

      ref.read(validatedDocumentsProvider.notifier).state = {
        ...ref.read(validatedDocumentsProvider),
        documentType: true,
      };
    }

    final computedProps = _resolveUploadProps(
      props: props,
      isUploaded: isUploaded,
      uploadedPath: uploadedPath,
    );

    final effectiveTheme = _resolveEffectiveTheme(
      theme: theme,
      isUploaded: isUploaded,
    );

    if (layout.isNotEmpty) {
      return Container(
        margin: ElementSettings.margin(classes),
        child: _buildLayoutDrivenUploadCard(
          context: context,
          layout: layout,
          props: computedProps,
          theme: effectiveTheme,
          config: config,
          isUploaded: isUploaded,
          uploadedPath: uploadedPath,
          onPickGallery: () => pickDocument(ImageSource.gallery),
          onPickCamera: () => pickDocument(ImageSource.camera),
        ),
      );
    }

    return _legacyDocumentUploadCard(
      context: context,
      classes: classes,
      props: computedProps,
      theme: effectiveTheme,
      isUploaded: isUploaded,
      uploadedPath: uploadedPath,
      onPickGallery: () => pickDocument(ImageSource.gallery),
      onPickCamera: () => pickDocument(ImageSource.camera),
    );
  }

  Map<dynamic, dynamic> _resolveUploadProps({
    required Map<dynamic, dynamic> props,
    required bool isUploaded,
    required String? uploadedPath,
  }) {
    final fileName = uploadedPath == null || uploadedPath.isEmpty
        ? ''
        : uploadedPath.split('/').last;

    return {
      ...props,
      "isUploaded": isUploaded,
      "uploadedPath": uploadedPath,
      "fileName": fileName,
      "icon": isUploaded
          ? props['uploadedIcon'] ?? 'check_circle'
          : props['icon'] ?? 'document',
      "subtitle": isUploaded
          ? props['uploadedLabel'] ?? 'Uploaded successfully'
          : props['subtitle'] ?? '',
      "uploadIcon": props['uploadIcon'] ?? 'upload',
      "uploadTitle": props['uploadTitle'] ?? 'Upload from device',
      "uploadSubtitle": props['uploadSubtitle'] ?? '',
      "fileIcon": props['fileIcon'] ?? 'document',
      "fileStatusIcon": props['fileStatusIcon'] ?? 'check_circle',
    };
  }

  Map<dynamic, dynamic> _resolveEffectiveTheme({
    required Map<dynamic, dynamic> theme,
    required bool isUploaded,
  }) {
    if (!isUploaded) return theme;

    return {
      ...theme,
      "card": theme['uploadedCard'] ?? theme['card'],
      "iconBox": theme['uploadedIconBox'] ?? theme['iconBox'],
      "icon": theme['uploadedIcon'] ?? theme['icon'],
      "subtitle": theme['uploadedSubtitle'] ?? theme['subtitle'],
    };
  }

  Widget _buildLayoutDrivenUploadCard({
    required BuildContext context,
    required List<Map<dynamic, dynamic>> layout,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
    required Map<dynamic, dynamic> config,
    required bool isUploaded,
    required String? uploadedPath,
    required VoidCallback onPickGallery,
    required VoidCallback onPickCamera,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: layout.map((section) {
        return _DocumentUploadLayoutNode(
          node: section,
          props: props,
          theme: theme,
          config: config,
          isUploaded: isUploaded,
          uploadedPath: uploadedPath,
          onPickGallery: onPickGallery,
          onPickCamera: onPickCamera,
        );
      }).toList(),
    );
  }

  Widget _legacyDocumentUploadCard({
    required BuildContext context,
    required List<String> classes,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
    required bool isUploaded,
    required String? uploadedPath,
    required VoidCallback onPickGallery,
    required VoidCallback onPickCamera,
  }) {
    final cardClasses = ElementSettings.classList(theme['card']);
    final iconBoxClasses = ElementSettings.classList(theme['iconBox']);
    final iconClasses = ElementSettings.classList(theme['icon']);

    final uploadBoxClasses = ElementSettings.classList(theme['uploadBox']);
    final uploadIconClasses = ElementSettings.classList(theme['uploadIcon']);

    final buttonClasses = ElementSettings.classList(theme['button']);
    final buttonIconClasses = ElementSettings.classList(theme['buttonIcon']);

    final button = Map<dynamic, dynamic>.from(props['button'] ?? {});

    Widget uploadBox = Container(
      width: double.infinity,
      padding: ElementSettings.padding(uploadBoxClasses),
      decoration: ElementSettings.decoration(context, uploadBoxClasses),
      child: Column(
        children: [
          ElementIcons.show(
            context,
            props['uploadIcon']?.toString() ?? 'upload',
            size: 26,
            color: ElementSettings.textColor(context, uploadIconClasses),
          ),
          const SizedBox(height: 8),
          Text(
            props['uploadTitle']?.toString() ?? '',
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['uploadTitle']),
            ),
          ),
          if ((props['uploadSubtitle'] ?? '').toString().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              props['uploadSubtitle']?.toString() ?? '',
              style: ElementSettings.textStyle(
                context,
                ElementSettings.classList(theme['uploadSubtitle']),
              ),
            ),
          ],
        ],
      ),
    );

    uploadBox = _maybeDashedBorder(classes: uploadBoxClasses, child: uploadBox);

    return Container(
      margin: ElementSettings.margin(classes),
      padding: ElementSettings.padding(cardClasses),
      decoration: ElementSettings.decoration(context, cardClasses),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: ElementSettings.decoration(context, iconBoxClasses),
                child: ElementIcons.show(
                  context,
                  props['icon']?.toString() ?? 'document',
                  size: 16,
                  color: ElementSettings.textColor(context, iconClasses),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      props['title']?.toString() ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['title']),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      props['subtitle']?.toString() ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['subtitle']),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isUploaded)
            _UploadedFileRow(
              path: uploadedPath ?? '',
              props: props,
              theme: theme,
            )
          else
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onPickGallery,
              child: uploadBox,
            ),
          if (!isUploaded) ...[
            const SizedBox(height: 12),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onPickCamera,
              child: Container(
                width: double.infinity,
                padding: ElementSettings.padding(buttonClasses),
                decoration: ElementSettings.decoration(context, buttonClasses),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if ((button['icon'] ?? '').toString().isNotEmpty) ...[
                      ElementIcons.show(
                        context,
                        button['icon']?.toString() ?? '',
                        size: 16,
                        color: ElementSettings.textColor(
                          context,
                          buttonIconClasses,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      button['label']?.toString() ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['buttonLabel']),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _maybeDashedBorder({
    required List<String> classes,
    required Widget child,
  }) {
    if (!ElementSettings.hasDashedBorder(classes)) {
      return child;
    }

    return QDriveDashedBorder(classes: classes, child: child);
  }
}

class _DocumentUploadLayoutNode extends StatelessWidget {
  final Map<dynamic, dynamic> node;
  final Map<dynamic, dynamic> props;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;
  final bool isUploaded;
  final String? uploadedPath;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;

  const _DocumentUploadLayoutNode({
    required this.node,
    required this.props,
    required this.theme,
    required this.config,
    required this.isUploaded,
    required this.uploadedPath,
    required this.onPickGallery,
    required this.onPickCamera,
  });

  @override
  Widget build(BuildContext context) {
    final type = node['type']?.toString();

    if (type == 'column') {
      return _buildColumn(context);
    }

    if (type == 'row') {
      return _buildRow(context);
    }

    if (type == 'container') {
      return _buildContainer(context);
    }

    return JsonLayoutRenderer(
      node: node,
      data: props,
      locals: {"document": props},
      theme: theme,
      config: config,
      currency: '',
    );
  }

  Widget _buildColumn(BuildContext context) {
    final children = List<Map<dynamic, dynamic>>.from(node['children'] ?? []);
    final nodeClasses = ElementSettings.classList(node['classes']);

    return Container(
      margin: ElementSettings.margin(nodeClasses),
      padding: ElementSettings.padding(nodeClasses),
      child: Column(
        crossAxisAlignment: _crossAxis(node['crossAxis']),
        mainAxisAlignment: _mainAxis(node['mainAxis']),
        mainAxisSize: _mainAxisSize(node['mainAxisSize']),
        children: children.map((childNode) {
          return _withFlex(
            childNode,
            _DocumentUploadLayoutNode(
              node: childNode,
              props: props,
              theme: theme,
              config: config,
              isUploaded: isUploaded,
              uploadedPath: uploadedPath,
              onPickGallery: onPickGallery,
              onPickCamera: onPickCamera,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRow(BuildContext context) {
    final children = List<Map<dynamic, dynamic>>.from(node['children'] ?? []);
    final nodeClasses = ElementSettings.classList(node['classes']);

    return Container(
      margin: ElementSettings.margin(nodeClasses),
      padding: ElementSettings.padding(nodeClasses),
      child: Row(
        crossAxisAlignment: _crossAxis(node['crossAxis']),
        mainAxisAlignment: _mainAxis(node['mainAxis']),
        mainAxisSize: _mainAxisSize(node['mainAxisSize']),
        children: children.map((childNode) {
          return _withFlex(
            childNode,
            _DocumentUploadLayoutNode(
              node: childNode,
              props: props,
              theme: theme,
              config: config,
              isUploaded: isUploaded,
              uploadedPath: uploadedPath,
              onPickGallery: onPickGallery,
              onPickCamera: onPickCamera,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContainer(BuildContext context) {
    final themeKey = node['themeKey']?.toString();
    final nodeClasses = ElementSettings.classList(node['classes']);

    if (isUploaded && themeKey == 'uploadBox') {
      Widget uploadedRow = _UploadedFileRow(
        path: uploadedPath ?? '',
        props: props,
        theme: theme,
      );

      final margin = ElementSettings.margin(nodeClasses);

      if (margin != EdgeInsets.zero) {
        uploadedRow = Container(margin: margin, child: uploadedRow);
      }

      return uploadedRow;
    }

    if (isUploaded && themeKey == 'button') {
      return const SizedBox.shrink();
    }

    final themeClasses = ElementSettings.classList(theme[themeKey]);
    final classes = [...themeClasses, ...nodeClasses];

    final childNode = node['child'];
    Widget? child;

    if (childNode is Map) {
      child = _DocumentUploadLayoutNode(
        node: Map<dynamic, dynamic>.from(childNode),
        props: props,
        theme: theme,
        config: config,
        isUploaded: isUploaded,
        uploadedPath: uploadedPath,
        onPickGallery: onPickGallery,
        onPickCamera: onPickCamera,
      );
    }

    Widget result = Container(
      width: _containerWidth(context, themeKey, classes),
      height: _nodeHeight(node),
      padding: ElementSettings.padding(classes),
      decoration: ElementSettings.decoration(
        context,
        classes,
        borderSides: ElementSettings.stringList(node['borderSides']),
      ),
      alignment: _alignment(node['alignment'] ?? node['align']),
      child: child,
    );

    if (ElementSettings.hasDashedBorder(classes)) {
      result = QDriveDashedBorder(classes: classes, child: result);
    }

    final margin = ElementSettings.margin(nodeClasses);

    if (margin != EdgeInsets.zero) {
      result = Container(margin: margin, child: result);
    }

    if (themeKey == 'uploadBox') {
      result = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPickGallery,
        child: result,
      );
    }

    if (themeKey == 'button') {
      result = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPickCamera,
        child: result,
      );
    }

    return result;
  }

  Widget _withFlex(Map<dynamic, dynamic> childNode, Widget child) {
    final flex = childNode['flex'];

    if (flex is int && flex > 0) {
      return Expanded(flex: flex, child: child);
    }

    return child;
  }

  double? _containerWidth(
    BuildContext context,
    String? themeKey,
    List<String> classes,
  ) {
    if (node['fullWidth'] == true) {
      return double.infinity;
    }

    if (themeKey == 'card' ||
        themeKey == 'uploadBox' ||
        themeKey == 'button' ||
        themeKey == 'fileRow') {
      return double.infinity;
    }

    return _doubleOrNull(node['width']) ??
        ElementSettings.width(context, classes);
  }

  double? _nodeHeight(Map<dynamic, dynamic> node) {
    return _doubleOrNull(node['height']);
  }

  double? _doubleOrNull(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Alignment? _alignment(dynamic value) {
    switch (value) {
      case 'center':
        return Alignment.center;
      case 'left':
      case 'start':
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'right':
      case 'end':
      case 'centerRight':
        return Alignment.centerRight;
      case 'topLeft':
        return Alignment.topLeft;
      case 'topRight':
        return Alignment.topRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomRight':
        return Alignment.bottomRight;
      case 'topCenter':
        return Alignment.topCenter;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      default:
        return null;
    }
  }

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

  MainAxisSize _mainAxisSize(dynamic value) {
    switch (value) {
      case 'min':
        return MainAxisSize.min;
      case 'max':
      default:
        return MainAxisSize.max;
    }
  }
}

class _UploadedFileRow extends StatelessWidget {
  final String path;
  final Map<dynamic, dynamic> props;
  final Map<dynamic, dynamic> theme;

  const _UploadedFileRow({
    required this.path,
    required this.props,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = path.split('/').last;

    final fileRowClasses = ElementSettings.classList(
      theme['fileRow'] ?? ['bg-black', 'rounded-md', 'p-md'],
    );

    final fileIconBoxClasses = ElementSettings.classList(
      theme['fileIconBox'] ?? ['bg-card-soft', 'rounded-md'],
    );

    final fileIconClasses = ElementSettings.classList(
      theme['fileIcon'] ?? ['text-muted'],
    );

    final fileNameClasses = ElementSettings.classList(
      theme['fileName'] ?? ['text-body', 'text-xs', 'font-bold'],
    );

    final fileStatusIconClasses = ElementSettings.classList(
      theme['fileStatusIcon'] ?? ['text-success'],
    );

    return Container(
      width: double.infinity,
      padding: ElementSettings.padding(fileRowClasses),
      decoration: ElementSettings.decoration(context, fileRowClasses),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: ElementSettings.decoration(context, fileIconBoxClasses),
            child: ElementIcons.show(
              context,
              props['fileIcon']?.toString() ?? 'document',
              size: 16,
              color: ElementSettings.textColor(context, fileIconClasses),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              style: ElementSettings.textStyle(context, fileNameClasses),
            ),
          ),
          ElementIcons.show(
            context,
            props['fileStatusIcon']?.toString() ?? 'check_circle',
            size: 16,
            color: ElementSettings.textColor(context, fileStatusIconClasses),
          ),
        ],
      ),
    );
  }
}
