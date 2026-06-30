import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../providers/theme_provider.dart';
import '../routes/app_routes.dart';
import '../widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      Navigator.pushReplacementNamed(context, AppRoutes.chat);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.primaryContainer,
              colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: colorScheme.onPrimary,
                child: Icon(
                  Icons.smart_toy_outlined,
                  size: 48,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'DecoBot',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rule-based chatbot for offline conversations',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimary.withOpacity(0.9),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _lastMessageCount = 0;
  bool _lastTypingState = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(BuildContext context) async {
    final sent = await context.read<ChatProvider>().sendMessage(_controller.text);
    if (!mounted || !sent) {
      return;
    }

    _controller.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    if (_lastMessageCount != chatProvider.messages.length ||
        _lastTypingState != chatProvider.isTyping) {
      _lastMessageCount = chatProvider.messages.length;
      _lastTypingState = chatProvider.isTyping;
      _scrollToBottom();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('DecoBot'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.history),
            icon: const Icon(Icons.history),
            tooltip: 'Conversation History',
          ),
          IconButton(
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            tooltip: themeProvider.isDarkMode
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
          ),
          TextButton(
            onPressed: () => context.read<ChatProvider>().clearChat(),
            child: const Text('Clear Chat'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (chatProvider.isLoading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              itemCount:
                  chatProvider.messages.length + (chatProvider.isTyping ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                if (chatProvider.isTyping && index == chatProvider.messages.length) {
                  return const TypingIndicatorBubble();
                }

                final message = chatProvider.messages[index];
                return message.isUser
                    ? UserChatBubble(message: message.message)
                    : BotChatBubble(message: message.message);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _sendMessage(context),
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: chatProvider.canSend
                        ? () => _sendMessage(context)
                        : null,
                    child: const Text('Send'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation History'),
      ),
      body: chatProvider.historyMessages.isEmpty
          ? const Center(
              child: Text('No conversation history yet.'),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              itemCount: chatProvider.historyMessages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final message = chatProvider.historyMessages[index];
                return message.isUser
                    ? UserChatBubble(message: message.message)
                    : BotChatBubble(message: message.message);
              },
            ),
    );
  }
}
