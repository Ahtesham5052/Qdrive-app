import 'package:flutter/material.dart';
import '../renderer/element_renderer.dart';

class LayoutView extends StatelessWidget {
  final List<Map<dynamic, dynamic>> items;
  final double bottomPadding;

  const LayoutView({super.key, required this.items, this.bottomPadding = 16});

  @override
  Widget build(BuildContext context) {
    print("$items");
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ElementRenderer(data: items[index]);
      },
    );
  }
}
