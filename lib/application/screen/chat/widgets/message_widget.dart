import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';

class MessageWidget extends StatelessWidget {
  final ReceivedNearbyMessage message;
  final bool isMine;

  const MessageWidget({super.key, required this.message, required this.isMine});

  String getMessageText(ReceivedNearbyMessage message) {
    String text = '';

    message.content.byType(
      onTextRequest: (req) => text = req.value,
      onTextResponse: (res) => text = res.id,
    );

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final messageMaxWidth = MediaQuery.of(context).size.width * 0.8;
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
            child: Text(
              getMessageText(message),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
