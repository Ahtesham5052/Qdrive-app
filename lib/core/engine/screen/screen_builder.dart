
import 'package:Qdrive/app/configurations/app_config.dart';
import 'package:Qdrive/app/constants/app_constants.dart';
import 'package:Qdrive/core/engine/providers/inspection_provider.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/shared/widgets/app_bar.dart';
import 'package:Qdrive/core/features/checkout/providers/upload_document_provider.dart';

import 'layout_view.dart';
import '../renderer/element_renderer.dart';
import '../resolver/json_resolver.dart';

class ScreenBuilder extends ConsumerStatefulWidget {
  final Map<dynamic, dynamic> json;

  const ScreenBuilder({super.key, required this.json});

  @override
  ConsumerState<ScreenBuilder> createState() => _ScreenBuilderState();
}

class _ScreenBuilderState extends ConsumerState<ScreenBuilder> {
  Map<dynamic, dynamic>? _previousScreenJson;

  @override
  void initState() {
    super.initState();

    // Save the screen that was active before this route opened.
    _previousScreenJson = currentScreenJson;

    // Set this route as the current screen.
    currentScreenJson = widget.json;
  }

  @override
  void didUpdateWidget(covariant ScreenBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the same route receives a new JSON payload, update current screen too.
    if (!identical(oldWidget.json, widget.json)) {
      currentScreenJson = widget.json;
    }
  }

  @override
  void dispose() {
    // When this route is popped, restore the previous screen JSON.
    //
    // Important:
    // If this route was replaced and another screen already became current,
    // do not overwrite it.
    if (identical(currentScreenJson, widget.json) ||
        _sameScreenJson(currentScreenJson, widget.json)) {
      currentScreenJson = _previousScreenJson;
    }

    super.dispose();
  }

  bool _sameScreenJson(dynamic a, dynamic b) {
    if (a is! Map || b is! Map) return false;

    final aScreen = a['screen']?.toString();
    final bScreen = b['screen']?.toString();

    final aCacheKey = a['meta'] is Map
        ? a['meta']['cacheKey']?.toString()
        : null;
    final bCacheKey = b['meta'] is Map
        ? b['meta']['cacheKey']?.toString()
        : null;

    return aScreen == bScreen && aCacheKey == bCacheKey;
  }

  @override
  Widget build(BuildContext context) {
    /// Do NOT set currentScreenJson here.
    /// Build can run many times and should not control navigation state.

    final patchedJson = _patchUploadDocumentsStateIfNeeded(widget.json, ref);

    final resolvedJson = JsonResolver.resolve(patchedJson);

    final ui = Map<dynamic, dynamic>.from(resolvedJson['ui'] ?? {});
    final layout = List<Map<dynamic, dynamic>>.from(ui['layout'] ?? []);

    final showAppBar = ui['showAppBar'] != false;
    final showFloatingActionButton = ui['showFloatingActionButton'] != false;

    final normalItems = layout.where((item) {
      return item['type'] != 'floating_action_button' &&
          item['type'] != 'bottom_bar';
    }).toList();

    final returnVehicleState = ref.watch(returnVehicleUiProvider);

    final shouldShowReturnLaterBar =
        !(returnVehicleState.photosUploaded &&
            returnVehicleState.inspectionComplete);

    bool isScreenLevelVisible(Map<dynamic, dynamic> item) {
      final visibleWhen = item['visibleWhen'];

      if (visibleWhen == null) return true;
      if (visibleWhen is bool) return visibleWhen;

      if (visibleWhen is String) {
        final condition = visibleWhen.trim();

        if (condition == 'returnUi.showReturnLaterBar == true') {
          return shouldShowReturnLaterBar;
        }

        if (condition == 'returnUi.showReturnLaterBar == false') {
          return !shouldShowReturnLaterBar;
        }
      }

      return true;
    }

    final bottomBarItems = layout.where((item) {
      return item['type'] == 'bottom_bar' && isScreenLevelVisible(item);
    }).toList();

    final bottomBarItem = bottomBarItems.isNotEmpty
        ? bottomBarItems.first
        : null;

    final floatingItem = AppRuntimeConfig.floatingItem;

  
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                if (showAppBar) const QDriveAppBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: LayoutView(
                      items: normalItems,
                      bottomPadding: bottomBarItem != null ? 110 : 16,
                    ),
                  ),
                ),
              ],
            ),

            if (bottomBarItem != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ElementRenderer(data: bottomBarItem),
              ),

            if (showFloatingActionButton && floatingItem != null)
              Positioned(
                right: 22,
                bottom: bottomBarItem != null ? 78 : 22,
                child: ElementRenderer(data: floatingItem),
              ),
          ],
        ),
      ),
    );
  }

  // keep your existing _patchUploadDocumentsStateIfNeeded,
  // _isDocumentUploaded and _documentFileName methods below this

  /// Patches upload document state into JSON before JsonResolver runs.
  ///
  /// Why this is needed:
  /// - JSON fallback has uploaded: false
  /// - DocumentUploadCard updates Riverpod
  /// - JsonResolver cannot see Riverpod directly
  /// - So ScreenBuilder injects Riverpod upload state into JSON value
  Map<dynamic, dynamic> _patchUploadDocumentsStateIfNeeded(
    Map<dynamic, dynamic> sourceJson,
    WidgetRef ref,
  ) {
    /// Only patch the upload documents screen.
    if (sourceJson['screen'] != 'upload_documents') {
      return sourceJson;
    }

    /// This must be the same provider used inside DocumentUploadCard.
    ///
    /// If your provider name is different, change only this line.
    final uploadedDocuments = ref.watch(uploadedDocumentsProvider);

    final patchedJson = Map<dynamic, dynamic>.from(sourceJson);

    final dynamicData = Map<dynamic, dynamic>.from(
      patchedJson['dynamicData'] ?? {},
    );

    final documentsWrapper = Map<dynamic, dynamic>.from(
      dynamicData['documents'] ?? {},
    );

    /// Use existing value first, otherwise fallback.
    final baseDocuments = Map<dynamic, dynamic>.from(
      documentsWrapper['value'] is Map
          ? documentsWrapper['value']
          : documentsWrapper['fallback'] ?? {},
    );

    final uploads = Map<dynamic, dynamic>.from(baseDocuments['uploads'] ?? {});

    final drivingLicense = Map<dynamic, dynamic>.from(
      uploads['driving_license'] ?? {},
    );

    final identityDocument = Map<dynamic, dynamic>.from(
      uploads['identity_document'] ?? {},
    );

    final drivingLicenseUploaded = _isDocumentUploaded(uploadedDocuments, [
      'driving_license',
      'drivingLicense',
    ]);

    final identityDocumentUploaded = _isDocumentUploaded(uploadedDocuments, [
      'identity_document',
      'identityDocument',
    ]);

    drivingLicense['uploaded'] = drivingLicenseUploaded;
    identityDocument['uploaded'] = identityDocumentUploaded;

    final drivingLicenseFileName = _documentFileName(uploadedDocuments, [
      'driving_license',
      'drivingLicense',
    ]);

    final identityDocumentFileName = _documentFileName(uploadedDocuments, [
      'identity_document',
      'identityDocument',
    ]);

    if (drivingLicenseFileName != null) {
      drivingLicense['fileName'] = drivingLicenseFileName;
    }

    if (identityDocumentFileName != null) {
      identityDocument['fileName'] = identityDocumentFileName;
    }

    uploads['driving_license'] = drivingLicense;
    uploads['identity_document'] = identityDocument;

    final uploadedCount = [
      drivingLicenseUploaded,
      identityDocumentUploaded,
    ].where((uploaded) => uploaded).length;

    baseDocuments['uploads'] = uploads;
    baseDocuments['uploadedCount'] = uploadedCount;
    baseDocuments['totalRequired'] = 2;
    baseDocuments['progress'] = uploadedCount / 2;
    baseDocuments['progressLabel'] = 'Upload Progress';
    baseDocuments['progressValue'] = '$uploadedCount/2';

    /// IMPORTANT:
    /// Put patched data into value.
    /// JsonResolver prefers value over fallback.
    documentsWrapper['value'] = baseDocuments;

    dynamicData['documents'] = documentsWrapper;
    patchedJson['dynamicData'] = dynamicData;

    return patchedJson;
  }

  /// Checks whether a document is uploaded from Riverpod state.
  ///
  /// This supports common provider shapes:
  /// - {"driving_license": true}
  /// - {"driving_license": {"uploaded": true}}
  /// - {"driving_license": {"fileName": "..."}}
  /// - {"driving_license": XFile/File/object}
  bool _isDocumentUploaded(
    dynamic uploadedDocuments,
    List<String> possibleKeys,
  ) {
    if (uploadedDocuments is! Map) return false;

    for (final key in possibleKeys) {
      if (!uploadedDocuments.containsKey(key)) continue;

      final value = uploadedDocuments[key];

      if (value == null) return false;

      if (value is bool) {
        return value;
      }

      if (value is Map) {
        if (value['uploaded'] == true) return true;
        if (value['fileName'] != null) return true;
        if (value['file'] != null) return true;
        if (value['path'] != null) return true;

        return false;
      }

      /// Any non-null file/object means uploaded.
      return true;
    }

    return false;
  }

  /// Reads uploaded file name from Riverpod state if available.
  String? _documentFileName(
    dynamic uploadedDocuments,
    List<String> possibleKeys,
  ) {
    if (uploadedDocuments is! Map) return null;

    for (final key in possibleKeys) {
      if (!uploadedDocuments.containsKey(key)) continue;

      final value = uploadedDocuments[key];

      if (value == null) return null;

      if (value is Map) {
        final fileName = value['fileName']?.toString();
        if (fileName != null && fileName.isNotEmpty) {
          return fileName;
        }

        final path = value['path']?.toString();
        if (path != null && path.isNotEmpty) {
          return path.split('/').last;
        }
      }

      try {
        final path = value.path?.toString();
        if (path != null && path.isNotEmpty) {
          return path.split('/').last;
        }
      } catch (_) {
        return null;
      }
    }

    return null;
  }
}
