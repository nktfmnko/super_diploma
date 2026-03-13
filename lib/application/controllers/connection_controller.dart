import 'dart:async';
import 'package:flutter/material.dart';
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
  final INearbyConnectionService _connectionService;
  final NearbyDevice _device;
  StreamSubscription? _statusSubscription;

  late ConnectionStatus _status;

  ConnectionStatus get status => _status;

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  ConnectionController({
    required this._connectionService,
    required this._device,
  }) {
    _status = _mapDeviceToStatus(_device);
    _subscribeToStatus();
  }

  void _subscribeToStatus() {
    _statusSubscription = _connectionService
        .getConnectedDeviceStream(_device.info.id)
        .listen((deviceFromStream) {
          if (_isProcessing) return;
          final newStatus = _mapDeviceToStatus(deviceFromStream);
          _updateStatus(newStatus);
        });
  }

  ConnectionStatus _mapDeviceToStatus(NearbyDevice? device) {
    if (device == null) return ConnectionStatus.disconnected;

    final s = device.status;

    if (s.isConnected) return ConnectionStatus.connected;
    if (s.isConnecting) return ConnectionStatus.connecting;
    if (s.isFailed) return ConnectionStatus.error;

    if (s.isAvailable || s.isUnavailable) {
      return ConnectionStatus.disconnected;
    }

    return ConnectionStatus.disconnected;
  }

  Future<void> handleAction() async {
    if (_isProcessing) return;

    _isProcessing = true;

    try {
      if (_status == ConnectionStatus.connected) {
        _updateStatus(ConnectionStatus.disconnecting);
        await _connectionService.disconnect(_device);
      } else {
        _updateStatus(ConnectionStatus.connecting);
        final success = await _connectionService.connect(_device);
        if (!success) {
          _updateStatus(ConnectionStatus.error);
        }
      }
    } on ConnectivityException {
      _updateStatus(ConnectionStatus.error);
      rethrow;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void _updateStatus(ConnectionStatus newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    notifyListeners();
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }
}
