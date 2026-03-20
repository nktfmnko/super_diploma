import 'package:drift/drift.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/infrastructure/datasources/database.dart';
import 'package:super_diploma/infrastructure/datasources/tables/messages.dart';

part 'messages_dao.g.dart';

@DriftAccessor(tables: [Messages])
class MessagesDao extends DatabaseAccessor<AppDatabase>
    with _$MessagesDaoMixin {
  MessagesDao(super.attachedDatabase);

  Future<void> insertMessage(ReceivedNearbyMessage msg, String chatId) async {
    await into(
      messages,
    ).insert(MessagesCompanion(messageData: Value(msg), chatId: Value(chatId)));
  }

  Future<void> deleteHistory(String chatId) async {
    await (delete(messages)..where((t) => t.chatId.equals(chatId))).go();
  }

  Stream<List<ReceivedNearbyMessage<NearbyMessageContent>>>
  watchMessagesByChatId(String chatId) {
    return (select(messages)
          ..where((m) => m.chatId.equals(chatId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.receivedAt, mode: OrderingMode.asc),
          ]))
        .watch()
        .map((rows) => rows.map((row) => row.messageData).toList());
  }
}
