import 'package:nearby_service/nearby_service.dart';

abstract interface class INearbyDiscoveryService {
  /// Метод, который запускает поиск ближайших устройств.
  /// Может выбросить исключение подтипа [NearbyDiscoveryServiceException]
  Future<void> startDiscovery();

  /// Метод, который отменяет поиск ближайших устройств.
  /// Может выбросить исключение подтипа [NearbyDiscoveryServiceException]
  Future<void> stopDiscovery();

  /// Поток, транслирующий список найденных устройств.
  Stream<List<NearbyDevice>> get peersStream;

  /// Освобождает ресурсы, используемые сервисом.
  Future<void> dispose();
}

sealed class NearbyDiscoveryServiceException implements Exception {
  final String message;

  const NearbyDiscoveryServiceException(this.message);
}

/// Система занята. Пожалуйста, дождитесь завершения текущей операции, прежде чем начинать следующую.
class NearbyDiscoveryServiceBusyException
    extends NearbyDiscoveryServiceException {
  const NearbyDiscoveryServiceBusyException()
    : super(
        'Система занята. Пожалуйста, дождитесь завершения текущей операции, прежде чем начинать следующую.',
      );
}

/// P2P на этом устройстве не поддерживается.
class NearbyDiscoveryServiceP2PUnsupportedException
    extends NearbyDiscoveryServiceException {
  const NearbyDiscoveryServiceP2PUnsupportedException()
    : super('P2P на этом устройстве не поддерживается.');
}

/// Устройства не найдены. Запустите поиск
class NearbyDiscoveryServiceNoServiceRequestsException
    extends NearbyDiscoveryServiceException {
  const NearbyDiscoveryServiceNoServiceRequestsException()
    : super('Устройства не найдены. Запустите поиск');
}

/// Ошибка связи. Убедитесь, что Wi-Fi, GPS включен и попробуйте снова
class NearbyDiscoveryServiceGenericErrorException
    extends NearbyDiscoveryServiceException {
  const NearbyDiscoveryServiceGenericErrorException()
    : super(
        'Ошибка связи. Убедитесь, что Wi-Fi, GPS включен и попробуйте снова',
      );
}

/// Что-то пошло не так. Убедитесь, что Wi-Fi, GPS включен и попробуйте снова
class NearbyDiscoveryServiceUnknownException
    extends NearbyDiscoveryServiceException {
  const NearbyDiscoveryServiceUnknownException()
    : super(
        'Что-то пошло не так. Убедитесь, что Wi-Fi, GPS включен и попробуйте снова',
      );
}
