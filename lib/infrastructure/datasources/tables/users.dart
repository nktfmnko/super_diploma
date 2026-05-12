import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get deviceId => text().unique()();

  TextColumn get deviceName => text()();
}
