import 'dart:async';

import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/domain/repository/device_status_service.dart';

class DeviceStatusService implements IDeviceStatusService {
  final NearbyService _nearbyService;

  DeviceStatusService(this._nearbyService);

  @override
  Future<bool> checkPermissions() async {
    return await _nearbyService.android?.requestPermissions() ?? false;
  }

  @override
  Future<bool> checkWifiStatus() async {
    return await _nearbyService.android?.checkWifiService() ?? false;
  }
}
