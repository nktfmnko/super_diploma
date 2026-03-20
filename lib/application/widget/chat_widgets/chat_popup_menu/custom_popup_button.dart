import 'package:flutter/material.dart';
import 'package:super_diploma/application/widget/chat_widgets/chat_popup_menu/delete_chat_alert_dialog.dart';

class CustomPopupButton extends StatelessWidget {
  final Future<void> Function(String) deleteHistoryFunc;
  final String chatId;

  const CustomPopupButton({
    super.key,
    required this.deleteHistoryFunc,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      menuPadding: .all(5),
      itemBuilder: (BuildContext context) => [
        //TODO реализовать поиск
        PopupMenuItem(
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
              await deleteHistoryFunc(chatId);
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
