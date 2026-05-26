import 'package:flutter/material.dart';

import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';

class ActiveCard extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const ActiveCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final props = Map<dynamic, dynamic>.from(data['props'] ?? {});
    final theme = Map<dynamic, dynamic>.from(data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(data['config'] ?? {});
    final classes = ElementSettings.classList(data['classes']);

    final layout = _layoutList(config['layout']);

    final renderData = <String, dynamic>{
      ...props,
      'title': props['title'] ?? 'Active Rental',
      'subtitle': props['subtitle'] ?? props['vehicleName'] ?? '',
      'vehicleName': props['vehicleName'] ?? props['subtitle'] ?? '',
      'bookingId': props['bookingId'] ?? '',
      'endDate': props['endDate'] ?? '',
      'statusColor': props['statusColor'],
      'showClose': props['showClose'] == true,
      'canClose': props['canClose'] ?? props['showClose'] == true,
    };

    return Container(
      margin: ElementSettings.margin(classes),
      padding: ElementSettings.padding(classes),
      decoration: ElementSettings.decoration(context, classes),
      child: layout.isNotEmpty
          ? _ActiveCardConfigLayout(
              layout: layout,
              data: renderData,
              theme: theme,
              config: config,
            )
          : _ActiveCardLegacy(props: renderData, theme: theme),
    );
  }

  static List<Map<dynamic, dynamic>> _layoutList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<dynamic, dynamic>.from(item))
        .toList();
  }
}

class _ActiveCardConfigLayout extends StatelessWidget {
  final List<Map<dynamic, dynamic>> layout;
  final Map<dynamic, dynamic> data;
  final Map<dynamic, dynamic> theme;
  final Map<dynamic, dynamic> config;

  const _ActiveCardConfigLayout({
    required this.layout,
    required this.data,
    required this.theme,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final locals = <String, dynamic>{
      ...data,
      'canClose': data['canClose'] == true,
      'showClose': data['showClose'] == true,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: layout.map((node) {
        return JsonLayoutRenderer(
          node: Map<dynamic, dynamic>.from(node),
          data: data,
          theme: theme,
          config: config,
          currency: data['currency']?.toString() ?? 'GBP',
          locals: locals,
        );
      }).toList(),
    );
  }
}

class _ActiveCardLegacy extends StatelessWidget {
  final Map<dynamic, dynamic> props;
  final Map<dynamic, dynamic> theme;

  const _ActiveCardLegacy({required this.props, required this.theme});

  @override
  Widget build(BuildContext context) {
    final titleClasses = ElementSettings.classList(theme['title']);
    final subtitleClasses = ElementSettings.classList(theme['subtitle']);
    final bookingIdClasses = ElementSettings.classList(theme['bookingId']);
    final endDateClasses = ElementSettings.classList(theme['endDate']);
    final closeClasses = ElementSettings.classList(theme['close']);
    final closeIconClasses = ElementSettings.classList(theme['closeIcon']);

    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: ElementSettings.color(
              props['statusColor'],
              fallback: const Color(0xFF00C776),
            ),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                props['title']?.toString() ?? '',
                style: ElementSettings.textStyle(context, titleClasses),
              ),
              const SizedBox(height: 2),
              Text(
                props['subtitle']?.toString() ?? '',
                style: ElementSettings.textStyle(context, subtitleClasses),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              props['bookingId']?.toString() ?? '',
              style: ElementSettings.textStyle(context, bookingIdClasses),
            ),
            const SizedBox(height: 2),
            Text(
              props['endDate']?.toString() ?? '',
              style: ElementSettings.textStyle(context, endDateClasses),
            ),
          ],
        ),
        if (props['showClose'] == true || props['canClose'] == true) ...[
          const SizedBox(width: 10),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              debugPrint('legacy active card close tapped');
              ActionHandler.handle(context, {'type': 'close'});
            },
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: ElementSettings.decoration(context, closeClasses),
              child: Icon(
                Icons.close,
                size: 16,
                color: ElementSettings.textColor(context, closeIconClasses),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
