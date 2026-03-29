import 'package:drift/drift.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/domain/chat_message_entity.dart';
import 'package:super_diploma/infrastructure/datasources/database.dart';
import 'package:super_diploma/infrastructure/datasources/tables/messages.dart';

part 'messages_dao.g.dart';

@DriftAccessor(tables: [Messages])
class MessagesDao extends DatabaseAccessor<AppDatabase>
    with _$MessagesDaoMixin {
  MessagesDao(super.attachedDatabase);

  Future<void> insertMessage(ReceivedNearbyMessage msg, String chatId) async {
    await into(messages).insert(
      MessagesCompanion(
        messageData: Value(msg),
        chatId: Value(chatId),
        textContent: Value(msg.content.toString()),
      ),
    );
  }

  Future<void> insertFileMessage({
    required String chatId,
    required String pathToFile,
    required NearbyDeviceInfo sender,
  }) async {
    final fileContent = NearbyMessageFilesRequest.create(
      files: [NearbyFileInfo(path: pathToFile)],
    );
    final fileMessage = ReceivedNearbyMessage(
      content: fileContent,
      sender: sender,
    );

    await into(messages).insert(
      MessagesCompanion(
        messageData: Value(fileMessage),
        chatId: Value(chatId),
        textContent: Value(pathToFile.split('/').last),
        pathToFile: Value(pathToFile),
      ),
    );
  }

  Future<void> deleteHistory(String chatId) async {
    await (delete(messages)..where((t) => t.chatId.equals(chatId))).go();
  }

  Stream<List<ChatMessageEntity>> watchMessagesByChatId(
    String chatId, {
    int limit = 20,
  }) {
    return (select(messages)
          ..where((m) => m.chatId.equals(chatId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.receivedAt, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => ChatMessageEntity(
                  message: row.messageData,
                  id: row.id,
                  pathToFile: row.pathToFile,
                ),
              )
              .toList(),
        );
  }

  Future<List<ChatMessageEntity>> searchMessages(
    String chatId,
    String query,
  ) async {
    final rows =
        await (select(messages)..where(
              (tbl) =>
                  tbl.chatId.equals(chatId) & tbl.textContent.like('%$query%'),
            ))
            .get();

    return rows
        .map(
          (row) => ChatMessageEntity(
            message: row.messageData,
            id: row.id,
            pathToFile: row.pathToFile,
          ),
        )
        .toList();
  }
}
