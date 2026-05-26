import 'package:flutter/material.dart';
import 'package:Qdrive/core/engine/style/element_icons.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';

class HomeHero extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const HomeHero({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final props = data['props'] ?? {};
    final theme = data['theme'] ?? {};
    final classes = ElementSettings.classList(data['classes']);

    return Container(
      margin: ElementSettings.margin(classes),
      padding: ElementSettings.padding(
        ElementSettings.classList(theme['section']),
      ),
      decoration: BoxDecoration(
        color: ElementSettings.background(
          context,
          ElementSettings.classList(theme['section']),
        ),
        border: Border(
          bottom: BorderSide(
            color: ElementSettings.borderColor(context, ['border-muted']),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElementIcons.show(
                context,
                'layers',
                size: 34,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      props['brand'] ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['brand']),
                      ),
                    ),
                    Text(
                      props['tagline'] ?? '',
                      style: ElementSettings.textStyle(
                        context,
                        ElementSettings.classList(theme['tagline']),
                      ),
                    ),
                  ],
                ),
              ),
              ElementIcons.show(
                context,
                props['menuIcon'],
                size: 26,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 34),
          Row(
            children: [
              ElementIcons.show(
                context,
                props['locationIcon'],
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                props['location'] ?? '',
                style: ElementSettings.textStyle(
                  context,
                  ElementSettings.classList(theme['location']),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            props['title'] ?? '',
            style: ElementSettings.textStyle(
              context,
              ElementSettings.classList(theme['title']),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: ElementSettings.padding(
              ElementSettings.classList(theme['searchBox']),
            ),
            decoration: ElementSettings.decoration(
              context,
              ElementSettings.classList(theme['searchBox']),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    props['searchHint'] ?? '',
                    style: ElementSettings.textStyle(
                      context,
                      ElementSettings.classList(theme['searchText']),
                    ),
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: ElementSettings.decoration(
                    context,
                    ElementSettings.classList(theme['cameraBox']),
                  ),
                  child: Center(
                    child: ElementIcons.show(
                      context,
                      props['cameraIcon'],
                      size: 18,
                      color: ElementSettings.textColor(
                        context,
                        ElementSettings.classList(theme['cameraIcon']),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
