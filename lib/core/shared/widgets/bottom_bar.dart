import 'package:Qdrive/core/engine/providers/inspection_provider.dart.dart';
import 'package:Qdrive/core/utils/int_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_step_provider.dart';
import 'package:Qdrive/core/utils/currency.dart';

class BottomBar extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const BottomBar({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleWhen = data['visibleWhen']?.toString().trim();

    if (visibleWhen != null && visibleWhen.isNotEmpty) {
      final returnState = ref.watch(returnVehicleUiProvider);

      switch (visibleWhen) {
        case 'returnUi.photosUploaded == false':
          if (returnState.photosUploaded) return const SizedBox.shrink();
          break;

        case 'returnUi.photosUploaded == true':
          if (!returnState.photosUploaded) return const SizedBox.shrink();
          break;

        case 'returnUi.inspectionComplete == false':
          if (returnState.inspectionComplete) return const SizedBox.shrink();
          break;

        case 'returnUi.inspectionComplete == true':
          if (!returnState.inspectionComplete) return const SizedBox.shrink();
          break;

        case 'returnUi.showReturnLaterBar == false':
          if (returnState.showReturnLaterBar) return const SizedBox.shrink();
          break;

        case 'returnUi.showReturnLaterBar == true':
          if (!returnState.showReturnLaterBar) return const SizedBox.shrink();
          break;
      }
    }
    final props = data['props'] ?? {};
    final theme = data['theme'] ?? {};
    final classes = ElementSettings.classList(data['classes']);

    final mode = props['mode']?.toString();
    final price = props['price'] ?? {};
    final button = props['button'] ?? {};
    final hasBackButton = props['backLabel'] != null;

    final buttonClasses = ElementSettings.classList(theme['button']);

    late final Widget child;

    // Single full-width button mode.
    if (mode == 'single_button') {
      child = _SingleButtonActions(
        theme: theme,
        button: button,
        buttonClasses: buttonClasses,
      );
    }
    // Checkout mode with Back + Continue buttons.
    else if (hasBackButton) {
      child = _CheckoutBottomActions(
        props: props,
        theme: theme,
        button: button,
        buttonClasses: buttonClasses,
      );
    }
    // Normal price + action button mode.
    else {
      child = _PriceBottomActions(
        price: price,
        theme: theme,
        button: button,
        buttonClasses: buttonClasses,
      );
    }

    return Container(
      margin: ElementSettings.margin(classes),
      padding: ElementSettings.padding(classes),
      decoration: BoxDecoration(
        color: ElementSettings.background(context, classes),
        border: Border(
          top: BorderSide(color: ElementSettings.borderColor(context, classes)),
        ),
      ),
      child: child,
    );
  }
}

/// Runs a bottom bar button action.
///
/// Supports:
/// 1. Direct Dart callback: button['onTap']
/// 2. JSON action object: button['action']
///
/// Your ActionHandler signature is:
/// ActionHandler.handle(BuildContext context, Map<dynamic, dynamic>? action)
void _runBottomBarAction({
  required BuildContext context,
  required Map<dynamic, dynamic> button,
}) {
  final onTap = button['onTap'];

  // Allows custom Dart callback when passed directly.
  if (onTap is VoidCallback) {
    onTap();
    return;
  }

  final action = button['action'];

  // Sends JSON action to central ActionHandler.
  if (action is Map<dynamic, dynamic>) {
    ActionHandler.handle(context, action);
  }
}

class _SingleButtonActions extends StatelessWidget {
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> button;
  final List<String> buttonClasses;

  const _SingleButtonActions({
    required this.theme,
    required this.button,
    required this.buttonClasses,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _runBottomBarAction(context: context, button: button);
      },
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: ElementSettings.decoration(context, buttonClasses),
        alignment: Alignment.center,
        child: Text(
          button['label'] ?? 'Continue',
          style: ElementSettings.textStyle(
            context,
            ElementSettings.classList(theme['buttonLabel']),
          ),
        ),
      ),
    );
  }
}

class _CheckoutBottomActions extends ConsumerWidget {
  final Map<dynamic, dynamic> props;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> button;
  final List<String> buttonClasses;

  const _CheckoutBottomActions({
    required this.props,
    required this.theme,
    required this.button,
    required this.buttonClasses,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backButtonClasses = ElementSettings.classList(
      theme['backButton'] ?? ['bg-transparent', 'border-muted', 'rounded-lg'],
    );

    final currentStep = ref.watch(checkoutStepProvider);
    final totalSteps = intValue(props['totalSteps'], 6);

    final button = Map<dynamic, dynamic>.from(props['button'] ?? {});
    final normalLabel = button['label']?.toString() ?? 'Continue';
    final finalLabel = button['finalLabel']?.toString() ?? normalLabel;

    final buttonLabel = currentStep >= totalSteps ? finalLabel : normalLabel;

    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // If checkout is past step 1, go to previous checkout step.
            if (currentStep > 1) {
              ref.read(checkoutStepProvider.notifier).state = currentStep - 1;
              return;
            }

            // If JSON gives a back action, use ActionHandler.
            final backAction = props['backAction'];

            if (backAction is Map<dynamic, dynamic>) {
              ActionHandler.handle(context, backAction);
              return;
            }

            // Default fallback.
            Navigator.of(context).maybePop();
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ElementSettings.decoration(context, backButtonClasses),
            alignment: Alignment.center,
            child: Text(
              props['backLabel'] ?? 'Back',
              style: ElementSettings.textStyle(
                context,
                ElementSettings.classList(
                  theme['backButtonLabel'] ??
                      ['text-body', 'text-xs', 'font-bold'],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // Move to next checkout step until final step.
              if (currentStep < totalSteps) {
                ref.read(checkoutStepProvider.notifier).state = currentStep + 1;
                return;
              }
              print("bottom bar $button");

              // On final step, run the JSON button action.
              _runBottomBarAction(context: context, button: button);
            },
            child: Container(
              height: 48,
              decoration: ElementSettings.decoration(context, buttonClasses),
              alignment: Alignment.center,
              child: Text(
                buttonLabel,
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['buttonLabel']),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceBottomActions extends StatelessWidget {
  final Map<dynamic, dynamic> price;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> button;
  final List<String> buttonClasses;

  const _PriceBottomActions({
    required this.price,
    required this.theme,
    required this.button,
    required this.buttonClasses,
  });

  @override
  Widget build(BuildContext context) {
    final priceValue = price['value'];
    final currency = price['currency'] ?? 'USD';

    return Row(
      children: [
        Flexible(
          flex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                price['label'] ?? '',
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['priceLabel']),
                ),
              ),

              const SizedBox(height: 2),

              Row(
                children: [
                  Text(
                    '${currencySymbol(currency)}$priceValue',
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['priceValue']),
                    ),
                  ),

                  if ((price['suffix'] ?? '').toString().isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Text(
                      price['suffix'],
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['priceSuffix']),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _runBottomBarAction(context: context, button: button);
            },
            child: Container(
              height: 48,
              padding: ElementSettings.padding(buttonClasses),
              decoration: ElementSettings.decoration(context, buttonClasses),
              alignment: Alignment.center,
              child: Text(
                button['label'] ?? 'Continue',
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['buttonLabel']),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
