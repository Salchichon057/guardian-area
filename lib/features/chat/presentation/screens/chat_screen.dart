import 'package:flutter/material.dart';
import 'package:guardian_area/features/chat/domain/entities/message.dart';
import 'package:guardian_area/features/chat/presentation/providers/chat_provider.dart';
import 'package:guardian_area/features/chat/presentation/widgets/widgets.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
          ),
        ),
        title: const Text('Talk to device'),
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          Expanded(
            child: ListView.builder(
              controller: chatProvider.chatScrollController,
              itemCount: chatProvider.messagesList.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messagesList[index];
                return (message.fromWho == FromWho.device)
                    ? DeviceMessageBubble(message: message)
                    : MyMessageBubble(message: message);
              },
            ),
          ),
          MessageFieldBox(
            onValue: (value) {
              chatProvider.sendMessage(value);
            },
          ),
        ]),
      ),
    );
  }
}
