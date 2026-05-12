import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/domain/errors/connectivity_exception.dart';
import 'package:super_diploma/domain/repository/nearby_connection_service.dart';

enum ConnectionStatus {
  connecting,
  connected,
  disconnecting,
  disconnected,
  error;

  String get buttonText {
    switch (this) {
      case ConnectionStatus.connected:
        return 'Отключится';
      case ConnectionStatus.disconnected:
      case ConnectionStatus.error:
        return 'Подключится';
      case ConnectionStatus.connecting:
      case ConnectionStatus.disconnecting:
        return '';
    }
  }

  bool get isLoading =>
      this == ConnectionStatus.connecting ||
      this == ConnectionStatus.disconnecting;
}

class ConnectionController extends ChangeNotifier {
  final NearbyDevice _device;

  ConnectionController({required this._device}) {
    _status = _mapDeviceToStatus(_device);

    _subscribeToStatus();
  }

  final _connectionService = GetIt.I<INearbyConnectionService>();

  StreamSubscription? _statusSubscription;

  late ConnectionStatus _status;

  ConnectionStatus get status => _status;

  void _subscribeToStatus() {
    _statusSubscription?.cancel().catchError((e) {
      debugPrint('Стрим уже был закрыт: $e');
    });
    _statusSubscription = _connectionService
        .getConnectedDeviceStream(_device.info.id)
        .listen(
          (deviceFromStream) {
            final newStatus = _mapDeviceToStatus(deviceFromStream);
            _updateStatus(newStatus);
          },
          onError: (e) {
            debugPrint('Ошибка в стриме: $e');
            _updateStatus(ConnectionStatus.error);
          },
          cancelOnError: false,
        );
  }

  ConnectionStatus _mapDeviceToStatus(NearbyDevice? device) {
    if (device == null) return ConnectionStatus.disconnected;

    switch (device.status) {
      case NearbyDeviceStatus.connected:
        return ConnectionStatus.connected;
      case NearbyDeviceStatus.failed:
        return ConnectionStatus.error;
      case NearbyDeviceStatus.connecting:
        return ConnectionStatus.connecting;
      case NearbyDeviceStatus.available:
      case NearbyDeviceStatus.unavailable:
        return ConnectionStatus.disconnected;
    }
  }

  Future<void> handleAction() async {
    if (_status.isLoading) return;
    try {
      if (_status == ConnectionStatus.connected) {
        _updateStatus(ConnectionStatus.disconnecting);
        await _connectionService.disconnect(_device);
      } else {
        _updateStatus(ConnectionStatus.connecting);
        final success = await _connectionService.connect(_device);
        if (success) {
          //костыль, чтобы слушать стрим
          await Future.delayed(const Duration(seconds: 1));
          _subscribeToStatus();
        } else {
          _updateStatus(ConnectionStatus.error);
        }
      }
    } on ConnectivityException {
      _updateStatus(ConnectionStatus.error);
      rethrow;
    }
  }

  void _updateStatus(ConnectionStatus newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    notifyListeners();
  }

  @override
  void dispose() {
    _statusSubscription?.cancel().catchError((_) {});
    super.dispose();
  }
}
