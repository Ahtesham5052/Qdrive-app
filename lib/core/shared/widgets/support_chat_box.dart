import 'package:flutter/material.dart';
import 'package:Qdrive/core/engine/action_handler/action_handler.dart';
import 'package:Qdrive/core/engine/style/element_settings.dart';

class SupportChatBox extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  const SupportChatBox({super.key, required this.data});

  @override
  State<SupportChatBox> createState() => _SupportChatBoxState();
}

class _SupportChatBoxState extends State<SupportChatBox> {
  final TextEditingController _controller = TextEditingController();

  late final List<Map<String, String>> _messages = [
    {
      "text":
          widget.data['message']?.toString() ??
          "Welcome to your rental! How can we help you today?",
      "time": widget.data['time']?.toString() ?? "10:30 AM",
      "sender": "support",
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"text": text, "time": "Now", "sender": "user"});
    });

    ActionHandler.handle(context, {
      "type": "send_support_message",
      "params": {"message": text},
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Map<dynamic, dynamic>.from(widget.data['theme'] ?? {});

    final titleClasses = ElementSettings.classList(theme['title']);
    final cardClasses = ElementSettings.classList(theme['card']);
    final bubbleClasses = ElementSettings.classList(theme['bubble']);
    final userBubbleClasses = ElementSettings.classList(
      theme['userBubble'] ?? ['bg-primary', 'rounded-md', 'p-md'],
    );
    final messageClasses = ElementSettings.classList(theme['message']);
    final userMessageClasses = ElementSettings.classList(
      theme['userMessage'] ?? ['text-black', 'text-xs', 'font-bold'],
    );
    final timeClasses = ElementSettings.classList(theme['time']);
    final inputClasses = ElementSettings.classList(theme['input']);
    final placeholderClasses = ElementSettings.classList(theme['placeholder']);
    final sendButtonClasses = ElementSettings.classList(theme['sendButton']);
    final sendIconClasses = ElementSettings.classList(theme['sendIcon']);

    final title = widget.data['title']?.toString() ?? 'Support Chat';
    final placeholder =
        widget.data['placeholder']?.toString() ?? 'Type your message...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: ElementSettings.textStyle(context, titleClasses)),
        const SizedBox(height: 12),

        Container(
          padding: ElementSettings.padding(cardClasses),
          decoration: ElementSettings.decoration(context, cardClasses),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._messages.map((message) {
                final isUser = message['sender'] == 'user';

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.72,
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: ElementSettings.padding(
                      isUser ? userBubbleClasses : bubbleClasses,
                    ),
                    decoration: ElementSettings.decoration(
                      context,
                      isUser ? userBubbleClasses : bubbleClasses,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['text'] ?? '',
                          style: ElementSettings.textStyle(
                            context,
                            isUser ? userMessageClasses : messageClasses,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message['time'] ?? '',
                          style: ElementSettings.textStyle(
                            context,
                            timeClasses,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 6),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: ElementSettings.decoration(
                        context,
                        inputClasses,
                      ),
                      child: TextField(
                        controller: _controller,
                        style: ElementSettings.textStyle(context, [
                          'text-body',
                          'text-sm',
                        ]),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: placeholder,
                          hintStyle: ElementSettings.textStyle(
                            context,
                            placeholderClasses,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: ElementSettings.padding(sendButtonClasses),
                      decoration: ElementSettings.decoration(
                        context,
                        sendButtonClasses,
                      ),
                      child: Icon(
                        Icons.send,
                        size: 18,
                        color: ElementSettings.textColor(
                          context,
                          sendIconClasses,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
