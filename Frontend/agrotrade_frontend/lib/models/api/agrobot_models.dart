import 'json_helpers.dart';

class AgrobotResponse {
  final String chatId;
  final String response;

  const AgrobotResponse({required this.chatId, required this.response});

  factory AgrobotResponse.fromJson(Object? value) {
    final json = ensureJsonMap(value);
    return AgrobotResponse(
      chatId: readString(json, const ['ChatId', 'chatId']) ?? '',
      response: readString(json, const ['Response', 'response']) ?? '',
    );
  }
}

class AgrobotHistoryMessage {
  final String role;
  final String content;

  const AgrobotHistoryMessage({required this.role, required this.content});

  factory AgrobotHistoryMessage.fromJson(Object? value) {
    final json = ensureJsonMap(value);
    return AgrobotHistoryMessage(
      role: readString(json, const ['Role', 'role']) ?? '',
      content: readString(json, const ['Content', 'content']) ?? '',
    );
  }
}

class AgrobotConversation {
  final String chatId;
  final List<AgrobotHistoryMessage> history;

  const AgrobotConversation({required this.chatId, required this.history});

  factory AgrobotConversation.fromJson(Object? value) {
    final json = ensureJsonMap(value);
    final rawHistory = json['History'] ?? json['history'];
    return AgrobotConversation(
      chatId: readString(json, const ['ChatId', 'chatId']) ?? '',
      history: rawHistory is List
          ? rawHistory.map(AgrobotHistoryMessage.fromJson).toList()
          : const [],
    );
  }

  String get title {
    for (final message in history) {
      if (message.role.toLowerCase() == 'user') return message.content;
    }
    return 'Conversación';
  }

  String get preview => history.isEmpty ? '' : history.last.content;
}
