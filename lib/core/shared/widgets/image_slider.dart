import 'package:flutter/material.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';

class ImageSlider extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  final double fallbackHeight;

  const ImageSlider({super.key, required this.data, this.fallbackHeight = 220});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.data['currentIndex'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final classes = ElementSettings.classList(widget.data['classes']);
    final images = List<Map<dynamic, dynamic>>.from(
      widget.data['images'] ?? [],
    );

    final backgroundImageUrl = widget.data['backgroundImageUrl']?.toString();

    final dotClasses = ElementSettings.classList(widget.data['dotClasses']);
    final activeDotClasses = ElementSettings.classList(
      widget.data['activeDotClasses'],
    );

    final dotSize = widget.data['dotSize'];
    final activeDotSize = widget.data['activeDotSize'];
    final dotPosition = widget.data['dotPosition'];

    if (images.isEmpty) {
      return SizedBox(
        height: widget.fallbackHeight,
        width: double.infinity,
        child: Container(
          color: ElementSettings.background(context, ['bg-muted']),
          child: const Center(child: Icon(Icons.directions_car, size: 54)),
        ),
      );
    }

    return SizedBox(
      height: ElementSettings.height(context, classes) ?? widget.fallbackHeight,
      width: ElementSettings.width(context, classes) ?? double.infinity,
      child: Container(
        color: ElementSettings.background(context, classes),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (backgroundImageUrl != null && backgroundImageUrl.isNotEmpty)
              Image.network(
                backgroundImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) {
                  return const SizedBox.shrink();
                },
              ),

            PageView.builder(
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (context, index) {
                final image = images[index];
                final imageUrl = image['url']?.toString() ?? '';

                final isNetworkImage =
                    imageUrl.startsWith('http://') ||
                    imageUrl.startsWith('https://');

                if (isNetworkImage) {
                  return Image.network(
                    imageUrl,
                    fit: ElementSettings.boxFit(classes),
                    width: double.infinity,
                    errorBuilder: (_, __, ___) {
                      return _fallbackImage(context);
                    },
                  );
                }

                return Image.asset(
                  imageUrl,
                  fit: ElementSettings.boxFit(classes),
                  width: double.infinity,
                  errorBuilder: (_, __, ___) {
                    return _fallbackImage(context);
                  },
                );
              },
            ),

            if (widget.data['showDots'] == true)
              Positioned(
                left: 0,
                right: 0,
                bottom: ElementSettings.positionOffset(dotPosition),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (index) {
                    final active = index == currentIndex;
                    final usedClasses = active ? activeDotClasses : dotClasses;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      width: active
                          ? _activeDotWidth(activeDotSize)
                          : _inactiveDotSize(dotSize),
                      height: active
                          ? _activeDotHeight(activeDotSize)
                          : _inactiveDotSize(dotSize),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: ElementSettings.decoration(
                        context,
                        usedClasses,
                      ).copyWith(borderRadius: BorderRadius.circular(999)),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackImage(BuildContext context) {
    return Container(
      color: ElementSettings.background(context, ['bg-muted']),
      child: const Center(child: Icon(Icons.directions_car, size: 54)),
    );
  }

  double _inactiveDotSize(dynamic value) {
    switch (value?.toString()) {
      case 'dot-xs':
        return 5;
      case 'dot-sm':
        return 7;
      case 'dot-md':
        return 8;
      case 'dot-lg':
        return 10;
      default:
        return 7;
    }
  }

  double _activeDotWidth(dynamic value) {
    switch (value?.toString()) {
      case 'dot-xs':
        return 18;
      case 'dot-sm':
        return 24;
      case 'dot-md':
        return 30;
      case 'dot-lg':
        return 36;
      case 'dot-pill':
        return 32;
      default:
        return 30;
    }
  }

  double _activeDotHeight(dynamic value) {
    switch (value?.toString()) {
      case 'dot-xs':
        return 5;
      case 'dot-sm':
        return 6;
      case 'dot-md':
        return 6;
      case 'dot-lg':
        return 7;
      case 'dot-pill':
        return 6;
      default:
        return 6;
    }
  }
}
