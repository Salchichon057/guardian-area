import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  final ValueChanged<String> onValue;

  const MessageFieldBox({
    super.key,
    required this.onValue,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final textController = TextEditingController();
    final focusNode = FocusNode();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: focusNode,
              controller: textController,
              decoration: const InputDecoration(
                  hintText: 'Type /help to see options',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  hintStyle: TextStyle(
                    color: Color(0xFF08273A),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
              onTapOutside: (event) => focusNode.unfocus(),
              onSubmitted: (value) {
                textController.clear();
                focusNode.requestFocus();
                onValue(value);
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              final textValue = textController.value.text;
              if (textValue.isNotEmpty) {
                textController.clear();
                onValue(textValue);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: colors.primary, shape: BoxShape.circle),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
