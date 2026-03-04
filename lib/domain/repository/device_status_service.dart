abstract interface class IDeviceStatusService {
  Future<bool> checkPermissions();

  Future<bool> checkWifiStatus();
}
