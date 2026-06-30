import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../services/services.dart';

class ChatProvider extends ChangeNotifier {
  static const String _currentChatKey = 'chat_current_session';
  static const String _historyKey = 'chat_history';

  final ChatbotService _chatbotService = ChatbotService();
  final List<ChatMessage> _messages = [];
  final List<ChatMessage> _historyMessages = [];

  bool _isLoading = true;
  bool _isTyping = false;
  int _conversationVersion = 0;
  bool _isDisposed = false;

  ChatProvider() {
    _initialize();
  }

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  List<ChatMessage> get historyMessages => List.unmodifiable(_historyMessages);

  bool get isLoading => _isLoading;

  bool get isTyping => _isTyping;

  bool get canSend => !_isLoading && !_isTyping;

  Future<void> _initialize() async {
    final initializationVersion = _conversationVersion;

    try {
      await _chatbotService.loadResponses();
      await _restoreSavedState(initializationVersion);
    } catch (error) {
      debugPrint('ChatProvider initialization failed: $error');
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<bool> sendMessage(String rawText) async {
    final text = rawText.trim();
    final currentVersion = _conversationVersion;

    if (text.isEmpty || !canSend) {
      return false;
    }

    final userMessage = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      message: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _historyMessages.add(userMessage);
    _isTyping = true;
    _safeNotify();

    await _saveCurrentSession();
    await _saveHistory();

    await Future.delayed(const Duration(milliseconds: 600));

    if (_isDisposed || currentVersion != _conversationVersion) {
      return true;
    }

    final botReply = _chatbotService.getResponse(text);
    final botMessage = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      message: botReply,
      isUser: false,
      timestamp: DateTime.now(),
    );

    if (_isDisposed || currentVersion != _conversationVersion) {
      return true;
    }

    _messages.add(botMessage);
    _historyMessages.add(botMessage);
    _isTyping = false;
    _safeNotify();

    await _saveCurrentSession();
    await _saveHistory();
    return true;
  }

  Future<void> clearChat() async {
    _messages.clear();
    _isTyping = false;
    _conversationVersion++;
    _safeNotify();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentChatKey);
  }

  Future<void> _restoreSavedState(int initializationVersion) async {
    final prefs = await SharedPreferences.getInstance();

    final savedSession = prefs.getString(_currentChatKey);
    if (savedSession != null && savedSession.isNotEmpty) {
      final sessionMessages = _decodeMessages(savedSession);
      if (!_isDisposed && initializationVersion == _conversationVersion) {
        _messages
          ..clear()
          ..addAll(sessionMessages);
      }
    }

    final savedHistory = prefs.getString(_historyKey);
    if (savedHistory != null && savedHistory.isNotEmpty) {
      final historyMessages = _decodeMessages(savedHistory);
      if (!_isDisposed && initializationVersion == _conversationVersion) {
        _historyMessages
          ..clear()
          ..addAll(historyMessages);
      }
      return;
    }

    if (!_isDisposed && initializationVersion == _conversationVersion) {
      _historyMessages
        ..clear()
        ..addAll(_messages);
      await _saveHistory();
    }
  }

  List<ChatMessage> _decodeMessages(String rawJson) {
    final decoded = jsonDecode(rawJson);
    if (decoded is! List) {
      return [];
    }

    final restoredMessages = <ChatMessage>[];
    for (final item in decoded) {
      if (item is Map<String, dynamic>) {
        restoredMessages.add(ChatMessage.fromJson(item));
      } else if (item is Map) {
        restoredMessages.add(ChatMessage.fromJson(Map<String, dynamic>.from(item)));
      }
    }

    return restoredMessages;
  }

  Future<void> _saveCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedSession = jsonEncode(_messages.map((message) => message.toJson()).toList());
    await prefs.setString(_currentChatKey, encodedSession);
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedHistory = jsonEncode(_historyMessages.map((message) => message.toJson()).toList());
    await prefs.setString(_historyKey, encodedHistory);
  }

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
