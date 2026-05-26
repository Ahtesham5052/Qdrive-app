import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/shared/providers/toggle_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QDriveBillingToggle extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  const QDriveBillingToggle({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});

    /// Real selected value now comes from Riverpod.
    /// This makes the toggle actually switch.
    final selected = ref.watch(qdrivePassBillingProvider);

    final monthlyClasses = ElementSettings.classList(
      selected == 'monthly' ? theme['activeButton'] : theme['inactiveButton'],
    );

    final annualClasses = ElementSettings.classList(
      selected == 'annual' ? theme['activeButton'] : theme['inactiveButton'],
    );

    final monthlyLabelClasses = ElementSettings.classList(
      selected == 'monthly' ? theme['activeLabel'] : theme['inactiveLabel'],
    );

    final annualLabelClasses = ElementSettings.classList(
      selected == 'annual' ? theme['activeLabel'] : theme['inactiveLabel'],
    );

    final groupClasses = ElementSettings.classList(theme['group']);
    final badgeClasses = ElementSettings.classList(theme['badge']);
    final badgeTextClasses = ElementSettings.classList(theme['badgeText']);

    return Container(
      width: double.infinity,
      padding: ElementSettings.padding(groupClasses),
      decoration: ElementSettings.decoration(context, groupClasses),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ref.read(qdrivePassBillingProvider.notifier).state = 'monthly';

                final action = props['monthlyAction'];
                if (action is Map<dynamic, dynamic>) {
                  ActionHandler.handle(context, action);
                }
              },
              child: Container(
                height: 52,
                alignment: Alignment.center,
                decoration: ElementSettings.decoration(context, monthlyClasses),
                child: Text(
                  props['monthlyLabel']?.toString() ?? 'Monthly',
                  textAlign: TextAlign.center,
                  style: ElementSettings.textStyle(
                    context,
                    monthlyLabelClasses,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ref.read(qdrivePassBillingProvider.notifier).state = 'annual';

                final action = props['annualAction'];
                if (action is Map<dynamic, dynamic>) {
                  ActionHandler.handle(context, action);
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: ElementSettings.decoration(
                      context,
                      annualClasses,
                    ),
                    child: Text(
                      props['annualLabel']?.toString() ?? 'Annual',
                      textAlign: TextAlign.center,
                      style: ElementSettings.textStyle(
                        context,
                        annualLabelClasses,
                      ),
                    ),
                  ),

                  Positioned(
                    top: -12,
                    right: 10,
                    child: Container(
                      padding: ElementSettings.padding(badgeClasses),
                      decoration: ElementSettings.decoration(
                        context,
                        badgeClasses,
                      ),
                      child: Text(
                        props['annualBadge']?.toString() ?? 'Save 17%',
                        style: ElementSettings.textStyle(
                          context,
                          badgeTextClasses,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
