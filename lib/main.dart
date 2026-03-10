import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/application/screen/discovery_screen.dart';
import 'package:super_diploma/application/screen/get_permissions_screen.dart';
import 'package:super_diploma/domain/repository/nearby_discovery_service.dart';
import 'package:super_diploma/infrastructure/repository/nearby_discovery_service_impl.dart';

import 'domain/repository/device_status_service.dart';
import 'infrastructure/repository/device_status_service_impl.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<NearbyService>(NearbyService.getInstance());
  getIt.registerLazySingleton<IDeviceStatusService>(
    () => DeviceStatusService(getIt<NearbyService>()),
  );

  getIt.registerLazySingleton<INearbyDiscoveryService>(
    () => NearbyDiscoveryService(getIt<NearbyService>()),
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
      initialRoute: initialRoute,
      routes: {
        '/setup': (_) => const GetPermissionsScreen(),
        '/discovery': (_) => const DiscoveryScreen(),
      },
    );
  }
}
