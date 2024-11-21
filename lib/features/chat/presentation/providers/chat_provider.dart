import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_area/features/chat/domain/entities/message.dart';
import 'package:guardian_area/features/chat/infrastructure/datasources/chat_stream_datasource_impl.dart';
import 'package:guardian_area/features/chat/infrastructure/mappers/message_mapper.dart';
import 'package:guardian_area/shared/infrastructure/services/key_value_storage_provider.dart';

class ChatState {
  final List<Message> messages;
  final bool isConnected;
  final ScrollController scrollController;

  ChatState({
    required this.messages,
    required this.isConnected,
    required this.scrollController,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isConnected,
    ScrollController? scrollController,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isConnected: isConnected ?? this.isConnected,
      scrollController: scrollController ?? this.scrollController,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatStreamDatasourceImpl _datasource;
  final Ref _ref;

  ChatNotifier(this._datasource, this._ref)
      : super(ChatState(
          messages: [
            Message(
              text: 'Hello, how can I help you?',
              fromWho: FromWho.device,
            ),
            Message(
              text: 'Use /help to get a list of commands',
              fromWho: FromWho.device,
            ),
          ],
          isConnected: false,
          scrollController: ScrollController(),
        ));

  void connect() async {
    try {
      final roomId = await _ref
          .read(keyValueStorageServiceProvider)
          .getValue<String>('selectedApiKey');

      if (roomId == null || roomId.isEmpty || roomId == '123456789') {
        _addMessage(Message(
          text: 'Select a Device to connect to.',
          fromWho: FromWho.device,
        ));
        throw Exception('No roomId available for WebSocket connection.');
      }

      final stream = _datasource.connectToDevice(roomId);
      state = state.copyWith(isConnected: true);

      stream.listen(
        (deviceMessage) {
          final message = MessageMapper.fromDeviceMessage(deviceMessage);
          _addMessage(message);
        },
        onError: (error) {
          state = state.copyWith(isConnected: false);
          print('WebSocket error: $error');
        },
        onDone: () {
          state = state.copyWith(isConnected: false);
          print('WebSocket connection closed.');
        },
      );
    } catch (error) {
      state = state.copyWith(isConnected: false);
      print('Error connecting to WebSocket: $error');
    }
  }

  void sendMessage(String text) {
    if (text.isEmpty) return;

    final newMessage = Message(
      text: text,
      fromWho: FromWho.me,
    );
    _addMessage(newMessage);

    if (text.startsWith('/')) {
      _handleCommand(text);
    } else {
      // Usa el método del datasource para enviar el mensaje
      print('Sending message to server: $text');
      _datasource.sendMessage(text);
    }
  }

  void _handleCommand(String command) async {
    if (command == '/help') {
      _addMessage(Message(
        text:
            'Available Commands:\n/help - List commands\n/alarm - Activate the alarm',
        fromWho: FromWho.device,
      ));
    } else if (command == '/alarm') {
      print('Sending /alarm command to server');
      _datasource.sendMessage(command);
      _addMessage(Message(
        text: 'Alarm command sent to the server.',
        fromWho: FromWho.device,
      ));
    } else {
      _addMessage(Message(
        text: 'I do not understand the command.',
        fromWho: FromWho.device,
      ));
    }
  }

  void _addMessage(Message message) {
    state = state.copyWith(messages: [...state.messages, message]);
    _scrollToBottom();
  }

  void _scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    state.scrollController.animateTo(
      state.scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void disconnect() {
    _datasource.disconnect();
    if (state.isConnected) {
      state = state.copyWith(isConnected: false);
    }
  }

  void reset() {
    state = ChatState(
      messages: [
        Message(
          text: 'Hello, how can I help you?',
          fromWho: FromWho.device,
        ),
        Message(
          text: 'Use /help to get a list of commands',
          fromWho: FromWho.device,
        ),
      ],
      isConnected: false,
      scrollController: ScrollController(),
    );
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final datasource = ChatStreamDatasourceImpl();
  return ChatNotifier(datasource, ref);
});
