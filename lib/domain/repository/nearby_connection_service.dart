import 'package:nearby_service/nearby_service.dart';

abstract interface class INearbyConnectionService {
  /// Метод для подключения к выбранному устройству.
  /// Может выбросить исключение подтипа [ConnectivityException].
  Future<bool> connect(NearbyDevice device);

  /// Метод для отключения от выбранного устройства.
  /// Может выбросить исключение подтипа [ConnectivityException].
  Future<void> disconnect(NearbyDevice device);

  /// Поток, транслирующий статус подключения.
  Stream<NearbyDevice?> getConnectedDeviceStream(String deviceId);
}
