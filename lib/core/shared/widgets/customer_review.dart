// lib/core/features/return_vehicle/presentation/widgets/return_review_section.dart

import 'package:Qdrive/core/engine/providers/inspection_provider.dart.dart';
import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReturnReviewSection extends ConsumerStatefulWidget {
  final Map<dynamic, dynamic> data;

  const ReturnReviewSection({super.key, required this.data});

  @override
  ConsumerState<ReturnReviewSection> createState() =>
      _ReturnReviewSectionState();
}

class _ReturnReviewSectionState extends ConsumerState<ReturnReviewSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    final state = ref.read(returnVehicleUiProvider);
    _controller = TextEditingController(text: state.reviewText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<dynamic, dynamic> get _props {
    return Map<dynamic, dynamic>.from(widget.data['props'] ?? {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(returnVehicleUiProvider);

    if (!state.inspectionComplete) {
      return const SizedBox.shrink();
    }

    final props = _props;

    final title = props['title']?.toString() ?? 'Rate Your Experience';
    final question =
        props['question']?.toString() ?? 'How was your rental experience?';
    final label =
        props['label']?.toString() ?? 'Share your experience (optional)';
    final placeholder =
        props['placeholder']?.toString() ?? 'Tell us about your experience...';
    final buttonLabel = props['buttonLabel']?.toString() ?? 'Submit Review';

    final canSubmit = state.rating > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style:  TextStyle(
              color: ElementSettings.textColor(context, ['text-primary']),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    final selected = state.rating >= starValue;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ref.read(returnVehicleUiProvider.notifier).state = state
                            .copyWith(rating: starValue);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          selected ? Icons.star : Icons.star_border,
                          size: 36,
                          color: selected
                              ? const Color(0xFFFFC400)
                              : const Color(0xFF3A3A3A),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),

                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: _controller,
                  minLines: 4,
                  maxLines: 5,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: const Color(0xFF22C7B8),
                  onChanged: (value) {
                    final current = ref.read(returnVehicleUiProvider);

                    ref.read(returnVehicleUiProvider.notifier).state = current
                        .copyWith(reviewText: value);
                  },
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.all(16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: canSubmit
                      ? () {
                          ActionHandler.handle(context, {
                            'type': 'submit_return_review',
                            'params': {
                              'rating': state.rating,
                              'reviewText': state.reviewText,
                            },
                          });
                        }
                      : null,
                  child: Opacity(
                    opacity: canSubmit ? 1 : 0.55,
                    child: Container(
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        buttonLabel,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
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
