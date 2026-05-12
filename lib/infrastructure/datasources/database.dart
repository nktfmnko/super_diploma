import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/infrastructure/datasources/daos/messages_dao.dart';
import 'package:super_diploma/infrastructure/datasources/daos/users_dao.dart';
import 'package:super_diploma/infrastructure/datasources/tables/messages.dart';
import 'package:super_diploma/infrastructure/datasources/tables/users.dart';

import 'package:super_diploma/infrastructure/datasources/converters/message_converter.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Messages, Users], daos: [MessagesDao, UsersDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'app_database');
  }
}
