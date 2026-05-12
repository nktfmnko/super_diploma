import 'package:flutter/material.dart';
import 'package:super_diploma/application/screen/chat/widgets/messages_widgets/message_widget.dart';
import 'package:super_diploma/domain/chat_message_entity.dart';

class MessagesList extends StatefulWidget {
  final List<ChatMessageEntity> messages;
  final VoidCallback loadMore;
  final bool isLoading;

  const MessagesList({
    super.key,
    required this.messages,
    required this.loadMore,
    required this.isLoading,
  });

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        widget.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      reverse: true,
      padding: const .symmetric(horizontal: 8.0),
      itemCount: widget.messages.length + (widget.isLoading ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index == widget.messages.length) {
          return Center(child: CircularProgressIndicator());
        }
        final message = widget.messages[index];
        final isMine = message.message.sender.id == 'me';
        return MessageWidget(message: message, isMine: isMine);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
