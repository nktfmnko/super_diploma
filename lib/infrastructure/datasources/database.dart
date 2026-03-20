import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/infrastructure/datasources/daos/messages_dao.dart';
import 'package:super_diploma/infrastructure/datasources/tables/messages.dart';

import 'package:super_diploma/infrastructure/datasources/converters/message_converter.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Messages], daos: [MessagesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'app_database');
  }
}
