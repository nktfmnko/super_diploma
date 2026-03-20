import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/application/widget/chat_widgets/message_widget.dart';

class MessagesList extends StatefulWidget {
  final List<ReceivedNearbyMessage> messages;

  const MessagesList({super.key, required this.messages});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      reverse: true,
      itemCount: widget.messages.length,
      itemBuilder: (BuildContext context, int index) {
        final message = widget.messages[widget.messages.length - 1 - index];
        final isMine = message.sender.id == 'me';
        return MessageWidget(message: message, isMine: isMine);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
