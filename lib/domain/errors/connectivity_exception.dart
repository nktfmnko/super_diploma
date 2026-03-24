import 'package:nearby_service/nearby_service.dart';

sealed class ConnectivityException implements Exception {
  final String message;

  const ConnectivityException(this.message);
}

/// Система занята. Убедитесь, что Wi-Fi, GPS включен и попробуйте снова.
class ConnectivityBusyException extends ConnectivityException {
  const ConnectivityBusyException()
    : super(
        'Система занята. Убедитесь, что Wi-Fi, GPS включен и попробуйте снова',
      );
}

/// P2P на этом устройстве не поддерживается.
class ConnectivityP2PUnsupportedException extends ConnectivityException {
  const ConnectivityP2PUnsupportedException()
    : super('P2P на этом устройстве не поддерживается.');
}

/// Устройства не найдены. Запустите поиск.
class ConnectivityNoServiceRequestsException extends ConnectivityException {
  const ConnectivityNoServiceRequestsException()
    : super('Устройства не найдены. Запустите поиск');
}

/// Ошибка связи. Убедитесь, что Wi-Fi, GPS включен и попробуйте снова.
class ConnectivityGenericErrorException extends ConnectivityException {
  const ConnectivityGenericErrorException()
    : super(
        'Ошибка связи. Убедитесь, что Wi-Fi, GPS включен и попробуйте снова',
      );
}

/// Что-то пошло не так. Убедитесь, что Wi-Fi, GPS включен и попробуйте снова.
class ConnectivityUnknownException extends ConnectivityException {
  const ConnectivityUnknownException()
    : super(
        'Что-то пошло не так. Убедитесь, что Wi-Fi, GPS включен и попробуйте снова',
      );
}

Never handleConnectivityException(NearbyServiceException e) {
  switch (e) {
    case NearbyServiceBusyException():
      throw ConnectivityBusyException();
    case NearbyServiceP2PUnsupportedException():
      throw ConnectivityP2PUnsupportedException();
    case NearbyServiceNoServiceRequestsException():
      throw ConnectivityNoServiceRequestsException();
    case NearbyServiceGenericErrorException():
      throw ConnectivityGenericErrorException();
    case NearbyServiceUnknownException():
      throw ConnectivityUnknownException();
    default:
      throw ConnectivityUnknownException();
  }
}
