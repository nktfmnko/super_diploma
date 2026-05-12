import 'package:drift/drift.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/infrastructure/datasources/database.dart';
import 'package:super_diploma/infrastructure/datasources/tables/users.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.attachedDatabase);

  Future<List<User>> getAllUsers() async {
    return (select(users)..where((u) => u.deviceId.equals('me').not())).get();
  }

  Future<void> ensureUserExists(NearbyDeviceInfo device) async {
    await into(users).insert(
      UsersCompanion.insert(
        deviceId: device.id,
        deviceName: device.displayName,
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }
}
