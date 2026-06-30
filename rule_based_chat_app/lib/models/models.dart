class ChatMessage {
  // Unique identifier for this message.
  final String id;

  // The text content of the message.
  final String message;

  // True when the message was sent by the user.
  final bool isUser;

  // The time when the message was created.
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  // Converts the message into a JSON-friendly map for storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Recreates a ChatMessage from stored JSON data.
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      message: json['message'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
