// ==========================================
// DOCUMENT COMPLIANCE CARD
// Supports:
// 1. New config.layout row/column JSON format
// 2. Latest uploaded document compliance message
// 3. Dynamic fields using for_each
// 4. Riverpod upload visibility check
// 5. Old hardcoded fallback if config.layout is missing
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/upload_document_provider.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

/// Shows AI compliance feedback after documents are uploaded.
///
/// This widget supports two rendering modes:
///
/// 1. New layout-driven mode:
///    Uses `config.layout` and renders row/column/container/text/icon/for_each
///    through [JsonLayoutRenderer].
///
/// 2. Legacy fallback mode:
///    Uses the old hardcoded layout when `config.layout` is missing.
///
/// The card only appears when the uploaded document count is greater than or
/// equal to `showWhenUploadedCountAtLeast`.
class DocumentComplianceCard extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  /// Creates an AI compliance card from JSON.
  const DocumentComplianceCard({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ========================================
    // Uploaded document state
    // ========================================

    final uploaded = ref.watch(uploadedDocumentsProvider);
    final validating = ref.watch(validatingDocumentsProvider);
    final validated = ref.watch(validatedDocumentsProvider);

    // ========================================
    // Root classes
    // Example: ["mb-lg"]
    // ========================================

    final classes = ElementSettings.classList(data['classes']);

    // ========================================
    // Theme from JSON
    // Example:
    // card, iconBox, icon, titleIcon, checkIcon,
    // title, checkText, fieldBox, fieldLabel, fieldValue
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
    // title, titleIcon, checkIcon,
    // checksByDocumentType, fieldsByDocumentType
    // ========================================

    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    // ========================================
    // Visibility rule
    // ========================================

    final minCount = (props['showWhenUploadedCountAtLeast'] is num)
        ? (props['showWhenUploadedCountAtLeast'] as num).toInt()
        : 1;

    if (uploaded.length < minCount) {
      return const SizedBox.shrink();
    }

    final latestType = uploaded.keys.isNotEmpty
        ? uploaded.keys.last.toString()
        : '';

    final latestIsValidating =
        validating[latestType] == true || validated[latestType] != true;

    if (latestIsValidating) {
      return Container(
        margin: ElementSettings.margin(classes),
        child: _aiValidatingCard(context),
      );
    }

    // ========================================
    // Build computed compliance data.
    // This keeps row/column JSON simple:
    // - latestType
    // - latestCheck
    // - fields
    // ========================================

    final complianceData = _resolveComplianceData(
      uploaded: uploaded,
      props: props,
    );

    // ========================================
    // New layout-driven rendering
    // ========================================

    if (layout.isNotEmpty) {
      return Container(
        margin: ElementSettings.margin(classes),
        child: _buildLayoutDrivenComplianceCard(
          layout: layout,
          props: complianceData,
          theme: theme,
          config: config,
        ),
      );
    }

    // ========================================
    // Fallback for old JSON without config.layout
    // ========================================

    return _legacyComplianceCard(
      context: context,
      classes: classes,
      props: complianceData,
      theme: theme,
    );
  }

  Widget _aiValidatingCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1020),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E3A8A), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF93C5FD)),
              backgroundColor: Color(0xFF1E293B),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'AI Validating...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Checking expiry date, compliance & authenticity',
                  style: TextStyle(
                    color: Color(0xFF93C5FD),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Resolves latest uploaded document compliance data.
  //
  // Converts:
  // checksByDocumentType[latestType]
  // fieldsByDocumentType[latestType]
  //
  // Into:
  // latestCheck
  // fields
  //
  // So config.layout can simply use:
  // "key": "latestCheck"
  // "itemsKey": "fields"
  // ==========================================

  Map<dynamic, dynamic> _resolveComplianceData({
    required Map<dynamic, dynamic> uploaded,
    required Map<dynamic, dynamic> props,
  }) {
    final latestType = uploaded.keys.isNotEmpty
        ? uploaded.keys.last.toString()
        : '';

    final checks = Map<dynamic, dynamic>.from(
      props['checksByDocumentType'] ?? {},
    );

    final fieldsMap = Map<dynamic, dynamic>.from(
      props['fieldsByDocumentType'] ?? {},
    );

    final fields = List<Map<dynamic, dynamic>>.from(
      fieldsMap[latestType] ?? [],
    );

    final latestCheck =
        checks[latestType]?.toString() ?? 'Document verified successfully';

    return {
      ...props,

      // Main computed values for config.layout.
      "latestType": latestType,
      "latestCheck": latestCheck,
      "fields": fields,

      // Default icon for the left-side badge.
      "icon": props['icon'] ?? 'security',
    };
  }

  // ==========================================
  // Builds compliance card using config.layout.
  //
  // The resolved compliance data is passed as main data,
  // so keys like:
  // - title
  // - titleIcon
  // - checkIcon
  // - latestCheck
  // - fields
  //
  // work directly inside JSON.
  // ==========================================

  Widget _buildLayoutDrivenComplianceCard({
    required List<Map<dynamic, dynamic>> layout,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
    required Map<dynamic, dynamic> config,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: layout.map((section) {
        return JsonLayoutRenderer(
          node: section,

          // Keep resolved compliance values as main data.
          data: props,

          // Also expose as compliance for optional nested usage.
          locals: {"compliance": props},

          theme: theme,
          config: config,
          currency: '',
        );
      }).toList(),
    );
  }

  // ==========================================
  // Legacy fallback
  // Keeps old document compliance JSON working safely.
  // ==========================================

  Widget _legacyComplianceCard({
    required BuildContext context,
    required List<String> classes,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
  }) {
    // ========================================
    // Theme class resolution
    // ========================================

    final cardClasses = ElementSettings.classList(theme['card']);
    final iconBoxClasses = ElementSettings.classList(theme['iconBox']);

    final fields = List<Map<dynamic, dynamic>>.from(props['fields'] ?? []);

    // ========================================
    // Main card
    // ========================================

    return Container(
      margin: ElementSettings.margin(classes),
      padding: ElementSettings.padding(cardClasses),
      decoration: ElementSettings.decoration(context, cardClasses),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================
          // Header row
          // ==================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==============================
              // Left icon box
              // ==============================
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: ElementSettings.decoration(context, iconBoxClasses),
                child: ElementIcons.show(
                  context,
                  props['icon']?.toString() ?? 'security',
                  size: 16,
                  color: ElementSettings.textColor(
                    context,
                    ElementSettings.classList(theme['icon']),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // ==============================
              // Text content
              // ==============================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ========================
                    // Title row
                    // ========================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElementIcons.show(
                          context,
                          props['titleIcon']?.toString() ?? '',
                          size: 16,
                          color: ElementSettings.textColor(
                            context,
                            ElementSettings.classList(theme['titleIcon']),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            props['title']?.toString() ?? '',
                            softWrap: true,
                            style: ElementSettings.textStyle(
                              context,
                              ElementSettings.classList(theme['title']),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // ========================
                    // Check row
                    // ========================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElementIcons.show(
                          context,
                          props['checkIcon']?.toString() ?? '',
                          size: 16,
                          color: ElementSettings.textColor(
                            context,
                            ElementSettings.classList(theme['checkIcon']),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            props['latestCheck']?.toString() ??
                                'Document verified successfully',
                            softWrap: true,
                            style: ElementSettings.textStyle(
                              context,
                              ElementSettings.classList(theme['checkText']),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ==================================
          // Field boxes
          // ==================================
          if (fields.isNotEmpty) ...[
            const SizedBox(height: 12),

            Row(
              children: fields.map((field) {
                final boxClasses = ElementSettings.classList(theme['fieldBox']);

                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: ElementSettings.padding(boxClasses),
                    decoration: ElementSettings.decoration(context, boxClasses),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field['label']?.toString() ?? '',
                          style: ElementSettings.textStyle(
                            context,
                            ElementSettings.classList(theme['fieldLabel']),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          field['value']?.toString() ?? '',
                          style: ElementSettings.textStyle(
                            context,
                            ElementSettings.classList(theme['fieldValue']),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
