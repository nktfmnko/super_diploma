import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/application/screen/discovery/discovery_screen.dart';
import 'package:super_diploma/application/screen/permissions/get_permissions_screen.dart';
import 'package:super_diploma/domain/repository/nearby_connection_service.dart';
import 'package:super_diploma/domain/repository/nearby_discovery_service.dart';
import 'package:super_diploma/domain/repository/nearby_messaging_service.dart';
import 'package:super_diploma/infrastructure/repository/nearby_discovery_service_impl.dart';
import 'package:super_diploma/infrastructure/repository/nearby_messaging_service_impl.dart';

import 'domain/repository/device_status_service.dart';
import 'infrastructure/datasources/daos/messages_dao.dart';
import 'infrastructure/datasources/database.dart';
import 'infrastructure/repository/device_status_service_impl.dart';
import 'infrastructure/repository/nearby_connection_service_impl.dart';

final getIt = GetIt.instance;
final db = AppDatabase();

void setup() {
  getIt.registerSingleton<NearbyService>(NearbyService.getInstance());
  getIt.registerSingleton<AppDatabase>(db);

  getIt.registerLazySingleton<IDeviceStatusService>(
    () => DeviceStatusService(getIt<NearbyService>()),
  );

  getIt.registerLazySingleton<INearbyDiscoveryService>(
    () => NearbyDiscoveryService(getIt<NearbyService>()),
  );

  getIt.registerLazySingleton<INearbyConnectionService>(
    () => NearbyConnectionService(getIt<NearbyService>()),
  );

  getIt.registerLazySingleton<INearbyMessagingService>(
    () => NearbyMessagingService(getIt<NearbyService>()),
  );

  getIt.registerLazySingleton<MessagesDao>(
    () => MessagesDao(getIt<AppDatabase>()),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await GetIt.I<NearbyService>().initialize(data: NearbyInitializeData());
  final statusService = GetIt.I<IDeviceStatusService>();

  final results = await Future.wait([
    statusService.checkPermissions(),
    statusService.checkWifiStatus(),
  ]);

  final bool isPermissionsGranted = results[0];
  final bool isWifiEnabled = results[1];

  final String initialRoute = (isPermissionsGranted && isWifiEnabled)
      ? '/discovery'
      : '/setup';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/setup': (_) => GetPermissionsScreen(),
        '/discovery': (_) => DiscoveryScreen(),
      },
    );
  }
}
