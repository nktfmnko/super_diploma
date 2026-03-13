import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/domain/errors/connectivity_exception.dart';

abstract interface class INearbyDiscoveryService {
  /// Метод, который запускает поиск ближайших устройств.
  /// Может выбросить исключение подтипа [ConnectivityException]
  Future<void> startDiscovery();

  /// Метод, который отменяет поиск ближайших устройств.
  /// Может выбросить исключение подтипа [ConnectivityException]
  Future<void> stopDiscovery();

  /// Поток, транслирующий список найденных устройств.
  Stream<List<NearbyDevice>> get peersStream;

  /// Освобождает ресурсы, используемые сервисом.
  Future<void> dispose();
}
