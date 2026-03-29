import 'package:drift/drift.dart';
import 'package:super_diploma/infrastructure/datasources/converters/message_converter.dart';

class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get messageData => text().map(NearbyMessageConverter())();

  TextColumn get textContent => text().nullable()();

  TextColumn get chatId => text()();

  TextColumn get pathToFile => text().nullable()();

  DateTimeColumn get receivedAt => dateTime().withDefault(currentDateAndTime)();
}
