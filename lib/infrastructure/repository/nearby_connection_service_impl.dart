import 'dart:async';

import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/domain/errors/connectivity_exception.dart';
import 'package:super_diploma/domain/repository/nearby_connection_service.dart';

class NearbyConnectionService implements INearbyConnectionService {
  final NearbyService _nearbyService;

  NearbyConnectionService(this._nearbyService);

  @override
  Future<bool> connect(NearbyDevice device) async {
    final deviceId = device.info.id;

    try {
      final requestSent = await _nearbyService.connectById(deviceId);
      if (!requestSent && !device.status.isConnected) {
        return false;
      }

      if (device.status.isConnected) {
        return true;
      }
      final connectedDevice = await _nearbyService
          .getConnectedDeviceStreamById(deviceId)
          .firstWhere((d) => d != null && d.status.isConnected)
          .timeout(const Duration(seconds: 15), onTimeout: () => null);

      return connectedDevice != null;
    } on NearbyServiceException catch (e) {
      handleConnectivityException(e);
    }
    return false;
  }

  @override
  Future<void> disconnect(NearbyDevice device) async {
    try {
      await _nearbyService.disconnectById(device.info.id);
    } on NearbyServiceException catch (e) {
      handleConnectivityException(e);
    }
  }

  @override
  Stream<NearbyDevice?> getConnectedDeviceStream(String deviceId) {
    return _nearbyService.getConnectedDeviceStreamById(deviceId);
  }
}
