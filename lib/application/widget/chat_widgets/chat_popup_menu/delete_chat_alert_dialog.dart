import 'package:flutter/material.dart';

class DeleteChatAlertDialog extends StatelessWidget {
  const DeleteChatAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Удалить чат'),
      content: Text(
        'Вы уверены, что хотите удалить чат без возможности восстановления?',
        maxLines: 3,
        overflow: .ellipsis,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Отмена', style: TextStyle(color: Colors.blue),),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('Удалить чат', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
