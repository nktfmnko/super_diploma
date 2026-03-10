import 'package:nearby_service/nearby_service.dart';

abstract interface class INearbyConnectionService {
  Future<bool> connect(NearbyDevice device);

  Future<void> disconnect(NearbyDevice device);

  Stream<NearbyDevice?> getConnectedDeviceStream(String deviceId);
}
