class AIChatMessage {
  const AIChatMessage({
    required this.role,
    required this.content,
    required this.createdAt,
  });

  final String role;
  final String content;
  final DateTime createdAt;

  bool get isUser => role == 'user';
}

class AIChatReply {
  const AIChatReply({
    required this.conversationId,
    required this.messageId,
    required this.reply,
    required this.createdAt,
  });

  final String conversationId;
  final String messageId;
  final String reply;
  final DateTime createdAt;

  factory AIChatReply.fromJson(Map<String, dynamic> json) {
    return AIChatReply(
      conversationId: json['conversation_id'] as String,
      messageId: json['message_id'] as String,
      reply: json['reply'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
