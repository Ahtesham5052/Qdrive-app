// ==========================================
// LIST HEADER
// Fully layout-driven
// Sort state handled by Riverpod
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Qdrive/core/engine/style/element_settings.dart';
import 'package:Qdrive/core/engine/renderer/json_layout_renderer.dart';
import 'package:Qdrive/core/shared/providers/sort_provider.dart';

class ListHeader extends ConsumerStatefulWidget {
  final Map<dynamic, dynamic> data;

  const ListHeader({super.key, required this.data});

  @override
  ConsumerState<ListHeader> createState() => _ListHeaderState();
}

class _ListHeaderState extends ConsumerState<ListHeader> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _buttonKey = GlobalKey();

  OverlayEntry? _overlayEntry;

  final List<String> defaultSortOptions = const [
    'Relevance',
    'Price: Low to High',
    'Price: High to Low',
    'Highest Rated',
  ];

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleDropdown() {
    if (_overlayEntry != null) {
      _removeDropdown();
      return;
    }

    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final buttonSize = renderBox.size;

    final props = Map<dynamic, dynamic>.from(widget.data['props'] ?? {});

    // Resolver creates props['action'] from sortBind.
    final action = Map<dynamic, dynamic>.from(props['action'] ?? {});

    final rawOptions = action['options'];

    final sortOptions = rawOptions is List
        ? rawOptions.map((e) => e.toString()).toList()
        : defaultSortOptions;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final selectedLabel =
                ref.watch(sortLabelProvider) ??
                (sortOptions.isNotEmpty ? sortOptions.first : '');
            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _removeDropdown,
                    behavior: HitTestBehavior.translucent,
                    child: const SizedBox.expand(),
                  ),
                ),

                CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  targetAnchor: Alignment.bottomRight,
                  followerAnchor: Alignment.topRight,
                  offset: const Offset(0, 6),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: buttonSize.width,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        border: Border.all(color: const Color(0xFF5C5C5C)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: sortOptions.map((option) {
                          final isSelected = option == selectedLabel;

                          return InkWell(
                            onTap: () {
                              ref.read(sortLabelProvider.notifier).state =
                                  option;

                              _removeDropdown();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              color: isSelected
                                  ? const Color(0xFF2878D0)
                                  : Colors.transparent,
                              child: Text(
                                option,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final props = Map<dynamic, dynamic>.from(widget.data['props'] ?? {});
    final action = Map<dynamic, dynamic>.from(props['action'] ?? {});

    final rawOptions = action['options'];

    final sortOptions = rawOptions is List
        ? rawOptions.map((e) => e.toString()).toList()
        : defaultSortOptions;

    final selectedSortLabel =
        ref.watch(sortLabelProvider) ??
        (sortOptions.isNotEmpty ? sortOptions.first : '');

    final classes = ElementSettings.classList(widget.data['classes']);
    final theme = Map<dynamic, dynamic>.from(widget.data['theme'] ?? {});
    final config = Map<dynamic, dynamic>.from(widget.data['config'] ?? {});

    final layout = List<Map<dynamic, dynamic>>.from(config['layout'] ?? []);

    final renderData = {...props, "selectedSortLabel": selectedSortLabel};

    return Container(
      margin: ElementSettings.margin(classes),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          key: _buttonKey,
          onTap: _toggleDropdown,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: layout.map((section) {
              return JsonLayoutRenderer(
                node: section,
                data: renderData,
                theme: theme,
                config: config,
                currency: '',
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
