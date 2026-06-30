import 'package:flutter/material.dart';

class UserChatBubble extends StatelessWidget {
  // Message text shown inside the bubble.
  final String message;

  const UserChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: colorScheme.onPrimaryContainer),
        ),
      ),
    );
  }
}

class BotChatBubble extends StatelessWidget {
  // Message text shown inside the bubble.
  final String message;

  const BotChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(22),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: colorScheme.onSecondaryContainer),
        ),
      ),
    );
  }
}

class TypingIndicatorBubble extends StatelessWidget {
  const TypingIndicatorBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withOpacity(0.75),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(22),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Bot is typing',
              style: TextStyle(color: colorScheme.onSecondaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}
