import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_payment_provider.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

/// Reusable form section.
///
/// Responsibility:
/// - read JSON
/// - prepare form data
/// - check section-level payment visibility
/// - wrap rendered fields inside a real Flutter Form
/// - allow ActionHandler to validate using Form.maybeOf(context)
///
/// Form-specific rendering lives inside JsonLayoutRenderer:
/// - form_fields
/// - form_field
/// - grouped half-width fields
/// - TextFormField
/// - input formatters
/// - validators
class FormSection extends ConsumerStatefulWidget {
  final Map<dynamic, dynamic> data;

  const FormSection({super.key, required this.data});

  @override
  ConsumerState<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends ConsumerState<FormSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showValidationErrors = false;

  @override
  Widget build(BuildContext context) {
    final props = Map<dynamic, dynamic>.from(widget.data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(widget.data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(widget.data['config'] ?? {});
    final classes = ElementSettings.classList(widget.data['classes']);

    if (!_isVisibleForSelectedPayment(ref, props)) {
      return const SizedBox.shrink();
    }

    final fields = _mapList(props['fields']);
    final layout = _layoutList(config['layout']);

    final renderLayout = layout.isNotEmpty ? layout : _legacyLayout;

    final renderData = <String, dynamic>{
      ...props,
      "title": props['title'] ?? '',
      "fields": fields,
      "currency": props['currency'] ?? 'GBP',
    };

    return Container(
      width: double.infinity,
      margin: ElementSettings.margin(classes),
      padding: ElementSettings.padding(classes),
      child: Form(
        key: _formKey,
        autovalidateMode: _showValidationErrors
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        onChanged: () {
          if (_showValidationErrors) {
            _formKey.currentState?.validate();
          }
        },
        child: Builder(
          builder: (formContext) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: renderLayout.map((node) {
                return JsonLayoutRenderer(
                  node: node,
                  data: renderData,
                  theme: theme,
                  config: config,
                  currency: renderData['currency']?.toString() ?? 'GBP',
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  bool _isVisibleForSelectedPayment(
    WidgetRef ref,
    Map<dynamic, dynamic> props,
  ) {
    final paymentSectionId = props['paymentSectionId'];
    final showWhenPaymentId = props['showWhenPaymentId'];

    if (paymentSectionId is! String || showWhenPaymentId is! String) {
      return true;
    }

    final selectedPayments = ref.watch(selectedPaymentMethodProvider);

    final selectedPaymentId =
        selectedPayments[paymentSectionId]?.toString() ??
        props['selectedPaymentId']?.toString();

    if (selectedPaymentId == null) {
      return true;
    }

    return selectedPaymentId == showWhenPaymentId;
  }

  static List<Map<dynamic, dynamic>> _mapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();
  }

  static List<Map<dynamic, dynamic>> _layoutList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();
  }

  static const List<Map<dynamic, dynamic>> _legacyLayout = [
    {
      "type": "column",
      "crossAxis": "stretch",
      "children": [
        {"type": "text", "key": "title", "themeKey": "title"},
        {
          "type": "form_fields",
          "itemsKey": "fields",
          "classes": ["mt-md"],
        },
      ],
    },
  ];
}
