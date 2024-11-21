import 'package:flutter/material.dart';
import 'package:guardian_area/features/chat/domain/entities/message.dart';

// ChangeNotifier -> Puede notificar a los widgets que escuchan los cambios
class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();

  List<Message> messagesList = [
    Message(
      text: 'Hello, how can I help you?',
      fromWho: FromWho.device,
    ),
    Message(
        text: 'Use /help to get a list of commands', fromWho: FromWho.device),
  ];

  // Future -> Se utiliza para funciones asincronas (async)
  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    final newMessage = Message(text: text, fromWho: FromWho.me);
    messagesList.add(newMessage);

    if (text.startsWith('/help')) {
      deviceReply(text);
    }
    // Notificar a los widgets que escuchan los cambios
    // notifyListeners -> Notifica a los widgets que escuchan los cambios
    notifyListeners();
    moveScrollToBottom();
  }

  Future<void> deviceReply(String command) async {
    // Mensaje:
    if (command == '/help') {
      final deviceMessage = Message(
        text: 'Available Commands: \n/alarm - Activate the alarm',
        fromWho: FromWho.device,
      );
      messagesList.add(deviceMessage);
      notifyListeners();
      moveScrollToBottom();
    } else if (command == '/alarm') {
      final deviceMessage = Message(
        text: 'The alarm has been activated',
        fromWho: FromWho.device,
      );
      messagesList.add(deviceMessage);
      notifyListeners();
      moveScrollToBottom();
    } else {
      final deviceMessage = Message(
        text: 'I do not understand the command',
        fromWho: FromWho.device,
      );
      messagesList.add(deviceMessage);
      notifyListeners();
      moveScrollToBottom();
    }
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));

    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
