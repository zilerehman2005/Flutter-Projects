import 'dart:convert';

import 'package:flutter/services.dart';

class ChatbotService {
  final Map<String, String> _responses = {};

  static const String fallbackResponse =
      "I don't understand that yet. Try 'help' or 'topics'.";

  Future<void> loadResponses() async {
    final jsonString = await rootBundle.loadString('assets/responses.json');
    final decoded = json.decode(jsonString);

    _responses
      ..clear()
      ..addAll(_flattenResponses(decoded));
  }

  String sanitizeInput(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String getResponse(String input) {
    final cleanInput = sanitizeInput(input);
    return _responses[cleanInput] ?? fallbackResponse;
  }

  Map<String, String> _flattenResponses(dynamic decodedJson) {
    final flattened = <String, String>{};

    if (decodedJson is! Map<String, dynamic>) {
      return flattened;
    }

    final intents = decodedJson['intents'];
    if (intents is! Map<String, dynamic>) {
      return flattened;
    }

    for (final category in intents.values) {
      if (category is! Map<String, dynamic>) {
        continue;
      }

      for (final entry in category.entries) {
        final key = entry.key.trim().toLowerCase();
        final value = entry.value;

        if (value is String) {
          flattened[key] = value;
        }
      }
    }

    return flattened;
  }
}

