import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/chat/domain/entities/message.dart';
import 'package:guardian_area/features/chat/presentation/providers/chat_provider.dart';
import 'package:guardian_area/features/chat/presentation/widgets/widgets.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final ChatNotifier chatNotifier;

  @override
  void initState() {
    super.initState();
    // Inicializa el ChatNotifier y conecta el WebSocket
    chatNotifier = ref.read(chatProvider.notifier);
    Future.microtask(() => chatNotifier.connect());
  }

  @override
  void dispose() {
    Future.microtask(() {
      chatNotifier.reset();
      chatNotifier.disconnect();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Oculta el teclado al hacer clic fuera del campo de texto
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Talk to device',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: const _ChatView(),
      ),
    );
  }
}

class _ChatView extends ConsumerWidget {
  const _ChatView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa el estado del ChatNotifier
    final chatState = ref.watch(chatProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            // Lista de mensajes
            Expanded(
              child: ListView.builder(
                controller: chatState.scrollController,
                itemCount: chatState.messages.length,
                itemBuilder: (context, index) {
                  final message = chatState.messages[index];
                  return (message.fromWho == FromWho.device)
                      ? DeviceMessageBubble(message: message)
                      : MyMessageBubble(message: message);
                },
              ),
            ),

            // Campo para enviar mensajes
            MessageFieldBox(
              onValue: (value) {
                ref.read(chatProvider.notifier).sendMessage(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
