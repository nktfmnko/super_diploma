import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_diploma/application/screen/chat/widgets/messages_widgets/file_message_widget.dart';
import 'package:super_diploma/domain/chat_message_entity.dart';

class MessageWidget extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMine;

  const MessageWidget({super.key, required this.message, required this.isMine});

  String getMessageText(ChatMessageEntity message) {
    String text = '';

    message.message.content.byType(
      onTextRequest: (req) => text = req.value,
      //onTextResponse: (res) => text = res.id,
    );

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final messageMaxWidth = MediaQuery.of(context).size.width * 0.8;
    final messagePath = message.pathToFile;

    return Align(
      alignment: isMine ? .centerRight : .centerLeft,
      child: ConstrainedBox(
        constraints: .loose(.fromWidth(messageMaxWidth)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isMine ? Colors.blue : Colors.blueGrey,
            borderRadius: .all(.circular(14)),
          ),
          child: Padding(
            padding: const .symmetric(vertical: 8, horizontal: 12),
            child: messagePath != null
                ? FileMessageWidget(filePath: messagePath)
                : Text(
                    getMessageText(message),
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
