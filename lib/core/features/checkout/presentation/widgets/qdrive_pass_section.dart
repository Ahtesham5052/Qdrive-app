import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/features/checkout/providers/checkout_qdrive_pass_provider.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';

class QdrivePassSection extends ConsumerWidget {
  final Map<dynamic, dynamic> data;

  /// Currency is optional so old widget calls still work.
  /// JsonLayoutRenderer needs currency, so we provide a safe default.
  final String currency;

  const QdrivePassSection({
    super.key,
    required this.data,
    this.currency = 'GBP',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});
    final classes = ElementSettings.classList(data['classes']);

    final layout = config['layout'];

    final selectedPlan = ref.watch(selectedQdrivePassPlanOptionProvider);
    final expandedCoveragePlanId = ref.watch(
      expandedQdrivePassCoverageProvider,
    );

    /// If user has already selected a QDrive Pass, show the selected-state card.
    /// This keeps the business logic stable and avoids forcing selected-state UI
    /// into every JSON layout.
    if (selectedPlan != null) {
      final selectedState = Map<dynamic, dynamic>.from(
        props['selectedState'] ?? {},
      );

      return Container(
        margin: ElementSettings.margin(classes),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((props['title'] ?? '').toString().isNotEmpty) ...[
              Text(
                props['title'].toString(),
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['title']),
                ),
              ),
              const SizedBox(height: 12),
            ],

            _AddedMembershipCard(
              plan: selectedPlan,
              selectedState: selectedState,
              theme: theme,
              onRemove: () {
                ref.read(selectedQdrivePassPlanProvider.notifier).state = null;
                ref.read(selectedQdrivePassPlanOptionProvider.notifier).state =
                    null;
                ref.read(expandedQdrivePassCoverageProvider.notifier).state =
                    null;
              },
            ),
          ],
        ),
      );
    }

    /// New mode:
    /// Render section from config.layout using JsonLayoutRenderer.
    /// This supports your new JSON-driven checkout sections.
    if (layout is List && layout.isNotEmpty) {
      final rendererData = <String, dynamic>{
        ...props,

        /// Extra state made available to JSON renderer nodes.
        "selectedPlan": selectedPlan,
        "hasSelectedPlan": selectedPlan != null,
        "expandedCoveragePlanId": expandedCoveragePlanId,
      };

      return Container(
        margin: ElementSettings.margin(classes),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: layout.map((rawNode) {
            return JsonLayoutRenderer(
              node: Map<dynamic, dynamic>.from(rawNode),
              data: rendererData,
              theme: theme,
              config: config,
              currency: currency,
            );
          }).toList(),
        ),
      );
    }

    /// Legacy fallback:
    /// If old JSON has no config.layout, use the original hard-coded UI.
    return _legacyBuild(
      context: context,
      ref: ref,
      props: props,
      theme: theme,
      classes: classes,
      expandedCoveragePlanId: expandedCoveragePlanId,
    );
  }

  Widget _legacyBuild({
    required BuildContext context,
    required WidgetRef ref,
    required Map<dynamic, dynamic> props,
    required Map<dynamic, dynamic> theme,
    required List<String> classes,
    required String? expandedCoveragePlanId,
  }) {
    final options = List<Map<dynamic, dynamic>>.from(props['options'] ?? []);

    return Container(
      margin: ElementSettings.margin(classes),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            props['title'] ?? '',
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['title']),
            ),
          ),

          const SizedBox(height: 12),

          ...options.map((option) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _QdrivePassOption(
                option: option,
                theme: theme,
                expandedCoveragePlanId: expandedCoveragePlanId,
                onSelectPlan: (plan) {
                  final planId = plan['id']?.toString() ?? '';

                  ref.read(selectedQdrivePassPlanProvider.notifier).state =
                      planId;

                  ref
                          .read(selectedQdrivePassPlanOptionProvider.notifier)
                          .state =
                      plan;

                  ref.read(expandedQdrivePassCoverageProvider.notifier).state =
                      null;
                },
                onToggleCoverage: (planId) {
                  final current = ref.read(expandedQdrivePassCoverageProvider);

                  ref.read(expandedQdrivePassCoverageProvider.notifier).state =
                      current == planId ? null : planId;
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AddedMembershipCard extends StatelessWidget {
  final Map<dynamic, dynamic> plan;
  final Map<dynamic, dynamic> selectedState;
  final Map<dynamic, dynamic> theme;
  final VoidCallback onRemove;

  const _AddedMembershipCard({
    required this.plan,
    required this.selectedState,
    required this.theme,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cardClasses = ElementSettings.classList(theme['selectedOption']);

    final title = plan['title']?.toString() ?? '';
    final suffix = selectedState['titleSuffix']?.toString() ?? '';
    final description = selectedState['description']?.toString() ?? '';
    final removeLabel = selectedState['removeLabel']?.toString() ?? '';
    final icon = selectedState['icon']?.toString() ?? '';

    return Container(
      width: double.infinity,
      padding: ElementSettings.padding(cardClasses),
      decoration: ElementSettings.decoration(context, cardClasses),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon.isNotEmpty) ...[
            Icon(
              ElementIcons.get(icon),
              size: 18,
              color: ElementSettings.textColor(context, ['text-info']),
            ),
            const SizedBox(width: 10),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title $suffix',
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(theme['optionTitle']),
                  ),
                ),

                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['description']),
                    ),
                  ),
                ],

                if (removeLabel.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onRemove,
                    child: Text(
                      removeLabel,
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['link']),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QdrivePassOption extends StatelessWidget {
  final Map<dynamic, dynamic> option;
  final Map<dynamic, dynamic> theme;
  final String? expandedCoveragePlanId;
  final ValueChanged<Map<dynamic, dynamic>> onSelectPlan;
  final ValueChanged<String> onToggleCoverage;

  const _QdrivePassOption({
    required this.option,
    required this.theme,
    required this.expandedCoveragePlanId,
    required this.onSelectPlan,
    required this.onToggleCoverage,
  });

  @override
  Widget build(BuildContext context) {
    final selected = option['selected'] == true;

    final optionClasses = ElementSettings.classList(
      selected ? theme['selectedOption'] : theme['option'],
    );

    final plans = List<Map<dynamic, dynamic>>.from(option['plans'] ?? []);

    return Container(
      padding: ElementSettings.padding(optionClasses),
      decoration: ElementSettings.decoration(context, optionClasses),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if ((option['icon'] ?? '').toString().isNotEmpty) ...[
                Container(
                  width: 34,
                  height: 34,
                  decoration: ElementSettings.decoration(
                    context,
                    ElementSettings.classList(theme['iconBox']),
                  ),
                  child: Icon(
                    ElementIcons.get(option['icon']),
                    size: 16,
                    color: ElementSettings.textColor(
                      context,
                      ElementSettings.classList(theme['icon']),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],

              Expanded(
                child: Text(
                  option['title'] ?? '',
                  style: ElementSettings.textStyle(
                    context,
                    ElementSettings.classList(theme['optionTitle']),
                  ),
                ),
              ),
            ],
          ),

          if ((option['description'] ?? '').toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              option['description'],
              style: ElementSettings.textStyle(
                context,
                ElementSettings.classList(theme['description']),
              ),
            ),
          ],

          if (plans.isNotEmpty) ...[
            const SizedBox(height: 14),

            ...plans.map((plan) {
              final planId = plan['id']?.toString() ?? '';
              final coverageExpanded = expandedCoveragePlanId == planId;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PassPlanTile(
                  plan: plan,
                  theme: theme,
                  coverageExpanded: coverageExpanded,
                  onSelect: () => onSelectPlan(plan),
                  onToggleCoverage: () => onToggleCoverage(planId),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _PassPlanTile extends StatelessWidget {
  final Map<dynamic, dynamic> plan;
  final Map<dynamic, dynamic> theme;
  final bool coverageExpanded;
  final VoidCallback onSelect;
  final VoidCallback onToggleCoverage;

  const _PassPlanTile({
    required this.plan,
    required this.theme,
    required this.coverageExpanded,
    required this.onSelect,
    required this.onToggleCoverage,
  });

  @override
  Widget build(BuildContext context) {
    final planClasses = ElementSettings.classList(theme['plan']);

    final coverage = plan['coverage'] is Map<dynamic, dynamic>
        ? Map<dynamic, dynamic>.from(plan['coverage'])
        : <String, dynamic>{};

    final features = List<String>.from(coverage['features'] ?? []);
    final badge = (plan['badge'] ?? '').toString();

    final viewLabel = coverage['viewLabel']?.toString() ?? '';
    final hideLabel = coverage['hideLabel']?.toString() ?? '';
    final coverageLabel = coverageExpanded ? hideLabel : viewLabel;

    return Container(
      padding: ElementSettings.padding(planClasses),
      decoration: ElementSettings.decoration(context, planClasses),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSelect,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 7,
                        runSpacing: 4,
                        children: [
                          Text(
                            plan['title'] ?? '',
                            style: ElementSettings.textStyle(
                              context,
                              ElementSettings.classList(theme['planTitle']),
                            ),
                          ),

                          if (badge.isNotEmpty)
                            _PlanBadge(label: badge, theme: theme),
                        ],
                      ),

                      if ((plan['description'] ?? '')
                          .toString()
                          .isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          plan['description'],
                          style: ElementSettings.textStyle(
                            context,
                            ElementSettings.classList(theme['planDescription']),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      plan['price'] ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['planPrice']),
                      ),
                    ),

                    if ((plan['billing'] ?? '').toString().isNotEmpty)
                      Text(
                        plan['billing'],
                        style: ElementSettings.textStyle(
                          context,
                          ElementSettings.classList(theme['billing']),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          if (coverage.isNotEmpty && coverageLabel.isNotEmpty) ...[
            const SizedBox(height: 10),

            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggleCoverage,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    coverageLabel,
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['link']),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    coverageExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                    color: ElementSettings.textColor(
                      context,
                      ElementSettings.classList(theme['link']),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (coverageExpanded && coverage.isNotEmpty) ...[
            const SizedBox(height: 10),

            if ((coverage['billingNote'] ?? '').toString().isNotEmpty)
              Text(
                coverage['billingNote'],
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['billing']),
                ),
              ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: ElementSettings.decoration(
                context,
                ElementSettings.classList(theme['coverageBox']),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    ElementIcons.get(coverage['includedIcon']),
                    size: 14,
                    color: ElementSettings.textColor(
                      context,
                      ElementSettings.classList(theme['link']),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coverage['includedTitle'] ?? '',
                          style: ElementSettings.textStyle(
                            context,
                            ElementSettings.classList(theme['planTitle']),
                          ),
                        ),
                        if ((coverage['includedSubtitle'] ?? '')
                            .toString()
                            .isNotEmpty)
                          Text(
                            coverage['includedSubtitle'],
                            style: ElementSettings.textStyle(
                              context,
                              ElementSettings.classList(
                                theme['planDescription'],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (features.isNotEmpty) ...[
              const SizedBox(height: 12),

              ...features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 12,
                        color: ElementSettings.textColor(
                          context,
                          ElementSettings.classList(theme['link']),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: ElementSettings.textStyle(
                            context,
                            ElementSettings.classList(theme['featureText']),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],

            if ((coverage['bestFor'] ?? '').toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Divider(
                color: ElementSettings.borderColor(context, ['border-muted']),
                height: 1,
              ),
              const SizedBox(height: 8),
              Text(
                coverage['bestForLabel'] ?? '',
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['billing']),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                coverage['bestFor'],
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['planTitle']),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  final String label;
  final Map<dynamic, dynamic> theme;

  const _PlanBadge({required this.label, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: ElementSettings.borderColor(context, ['border-info']),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: ElementSettings.textStyle(
          context,
          ElementSettings.classList(theme['badge']),
          size: 9,
        ),
      ),
    );
  }
}
