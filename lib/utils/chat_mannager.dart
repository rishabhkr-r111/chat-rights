import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatManager {
  List<types.Message> messages = [];
  final user = const types.User(
    id: 'user',
  );
  final bot = const types.User(id: 'model', firstName: 'Chat Assistant');
  bool isLoading = false;
  late WebSocketChannel channel;

  void initializeWebsocket() {
    channel = WebSocketChannel.connect(
        Uri.parse('wss://api-chat-rights-35jloclotq-el.a.run.app/ws'));
  }

  void addMessage(types.Message message) {
    messages.insert(0, message);
    isLoading = true;
    if (message is types.TextMessage) {
      channel.sink.add(message.text); // sending text message to the backend api
      messages.insert(
          0,
          types.TextMessage(
            author: bot,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: "",
          ));
    }
  }

  void onMessageReceived(response) {
    if (response == "<FIN>") {
      isLoading = false;
    } else {
      messages.first = (messages.first as types.TextMessage).copyWith(
          text: (messages.first as types.TextMessage).text + response);
    }
  }
}
