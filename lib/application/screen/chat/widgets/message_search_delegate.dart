import 'package:flutter/material.dart';
import 'package:super_diploma/application/controllers/messaging_controller.dart';
import 'package:super_diploma/application/screen/chat/widgets/message_widget.dart';

class MessageSearchDelegate extends SearchDelegate {
  final String chatId;
  final MessagingController controller;

  MessageSearchDelegate({required this.chatId, required this.controller});

  @override
  String? get searchFieldLabel => 'Поиск';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear_rounded),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: controller.searchMessage(chatId, query),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка при поиске'));
          }
          final result = snapshot.data ?? [];
          if (result.isEmpty) {
            return const Center(child: Text('Ничего не найдено'));
          }

          return ListView.separated(
            padding: const .symmetric(horizontal: 8, vertical: 10),
            itemBuilder: (_, index) {
              final message = result[index];
              final isMine = message.sender.id == 'me';
              return MessageWidget(message: message, isMine: isMine);
            },
            separatorBuilder: (_, _) {
              return const SizedBox(height: 10);
            },
            itemCount: result.length,
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
