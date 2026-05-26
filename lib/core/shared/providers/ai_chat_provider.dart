import 'package:flutter_riverpod/legacy.dart';

class AiChatMessage {
  final String role; // user / assistant
  final String text;
  final String time;

  const AiChatMessage({
    required this.role,
    required this.text,
    required this.time,
  });
}

class AiChatState {
  final List<AiChatMessage> messages;
  final bool loading;

  const AiChatState({this.messages = const [], this.loading = false});

  AiChatState copyWith({List<AiChatMessage>? messages, bool? loading}) {
    return AiChatState(
      messages: messages ?? this.messages,
      loading: loading ?? this.loading,
    );
  }
}

class AiChatNotifier extends StateNotifier<AiChatState> {
  AiChatNotifier()
    : super(
        const AiChatState(
          messages: [
            AiChatMessage(
              role: 'assistant',
              text: 'Hi, I’m your QDrive AI Concierge. How can I help?',
              time: 'Now',
            ),
          ],
        ),
      );

  Future<void> send(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;

    final userMessage = AiChatMessage(role: 'user', text: clean, time: 'Now');

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      loading: true,
    );

    await Future.delayed(const Duration(milliseconds: 600));

    final aiMessage = AiChatMessage(
      role: 'assistant',
      text: _mockAiReply(clean),
      time: 'Now',
    );

    state = state.copyWith(
      messages: [...state.messages, aiMessage],
      loading: false,
    );
  }

  String _mockAiReply(String input) {
    final lower = input.toLowerCase();

    if (lower.contains('5 people') || lower.contains('family')) {
      return 'For 5 people, I recommend an SUV such as a BMW X5, Range Rover Vogue, or Mercedes GLE.';
    }

    if (lower.contains('insurance')) {
      return 'Insurance usually includes basic protection. You can add premium cover during checkout for lower excess and better peace of mind.';
    }

    if (lower.contains('electric')) {
      return 'I can show electric and hybrid cars such as Tesla Model Y, BMW iX, and Mercedes EQE SUV.';
    }

    return 'I can help you find vehicles, compare prices, explain insurance, check extras, or guide you through booking.';
  }
}

final aiChatProvider = StateNotifierProvider<AiChatNotifier, AiChatState>((
  ref,
) {
  return AiChatNotifier();
});
