import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/renderer/element_renderer.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_step_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/renderer/element_renderer.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_step_provider.dart';

class CheckoutFlow extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const CheckoutFlow({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});

    final providerStep = ref.watch(checkoutStepProvider);

    final steps = List<Map<dynamic, dynamic>>.from(props['steps'] ?? []);

    if (steps.isEmpty) return const SizedBox.shrink();

    final totalSteps = _intValue(
      props['totalSteps'] ?? config['totalSteps'] ?? steps.length,
      steps.length,
    );

    final safeStep = providerStep.clamp(1, totalSteps).toInt();

    final activeStep = steps.firstWhere(
      (step) => _intValue(step['step'], 1) == safeStep,
      orElse: () => steps.first,
    );

    final sections = List<Map<dynamic, dynamic>>.from(
      activeStep['sections'] ?? [],
    );

    final persistentSections = List<Map<dynamic, dynamic>>.from(
      props['persistentSections'] ?? [],
    );

    final header = Map<dynamic, dynamic>.from(config['header'] ?? {});

    final elements = <Map<dynamic, dynamic>>[
      {
        ...header,
        "theme": config['headerTheme'] ?? {},
        "props": {
          "title": activeStep['title'] ?? "Booking option",
          "label": activeStep['label'] ?? "",
          "stepText": activeStep['stepText'] ?? "Step $safeStep of $totalSteps",

          "currentStep": safeStep,
          "totalSteps": totalSteps,

          "showBack": header['showBack'] == true,
          "backIcon": header['backIcon'] ?? "arrow_back",
          "backAction": header['backAction'],

          "totalPrice": props['totalPrice'],
          "currency": props['currency'],
          "rentalPeriod": props['rentalPeriod'],
          "rentalDays": props['rentalDays'],

          "priceDetails": props['priceDetails'],
          "priceDetailsLabel": "Price details",
          "priceAction": header['priceAction'],
        },
      },

      // These show on every checkout step.
      ...persistentSections.map((section) {
        return _resolveCheckoutSection(section, props);
      }),

      // These show only for the current step.
      ...sections.map((section) {
        return _resolveCheckoutSection(section, props);
      }),

      if (config['priceBreakdown'] != null)
        Map<dynamic, dynamic>.from(config['priceBreakdown']),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: elements.map((element) {
        return ElementRenderer(data: element);
      }).toList(),
    );
  }

  Map<dynamic, dynamic> _resolveCheckoutSection(
    Map<dynamic, dynamic> section,
    Map<dynamic, dynamic> checkoutProps,
  ) {
    final resolved = Map<dynamic, dynamic>.from(section);

    final bind = resolved['bind']?.toString();

    if (bind != null && bind.isNotEmpty && checkoutProps[bind] is Map) {
      final boundProps = Map<dynamic, dynamic>.from(checkoutProps[bind]);

      resolved['props'] = {
        ...boundProps,
        ...Map<dynamic, dynamic>.from(resolved['props'] ?? {}),
      };
    }

    return resolved;
  }

  int _intValue(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}