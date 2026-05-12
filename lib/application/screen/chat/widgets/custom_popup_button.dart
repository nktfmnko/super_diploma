import 'package:flutter/material.dart';
import 'package:super_diploma/application/controllers/messaging_controller.dart';
import 'package:super_diploma/application/screen/chat/widgets/delete_chat_alert_dialog.dart';
import 'package:super_diploma/application/screen/chat/widgets/message_search_delegate.dart';

class CustomPopupButton extends StatelessWidget {
  final MessagingController controller;
  final String chatId;

  const CustomPopupButton({
    super.key,
    required this.chatId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      menuPadding: .all(5),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          onTap: () => showSearch(
            context: context,
            delegate: MessageSearchDelegate(
              chatId: chatId,
              controller: controller,
            ),
          ),
          child: Row(children: [const Icon(Icons.search), Text('Поиск')]),
        ),
        PopupMenuItem(
          onTap: () async {
            final result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return DeleteChatAlertDialog();
              },
            );
            if (result == 'OK') {
              await controller.deleteHistory(chatId);
            }
          },
          child: Row(
            mainAxisAlignment: .start,
            children: [const Icon(Icons.delete), Text('Удалить чат')],
          ),
        ),
      ],
    );
  }
}
