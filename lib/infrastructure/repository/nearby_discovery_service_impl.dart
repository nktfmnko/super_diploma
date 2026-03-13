import 'dart:async';

import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/domain/errors/connectivity_exception.dart';
import 'package:super_diploma/domain/repository/nearby_discovery_service.dart';

class NearbyDiscoveryService implements INearbyDiscoveryService {
  final NearbyService _nearbyService;
  StreamSubscription<List<NearbyDevice>>? _peersSubscriptions;

  final _peersController = StreamController<List<NearbyDevice>>.broadcast();

  NearbyDiscoveryService(this._nearbyService);

  @override
  Stream<List<NearbyDevice>> get peersStream => _peersController.stream;

  @override
  Future<void> startDiscovery() async {
    try {
      final ready = await _nearbyService.discover();
      if (ready) {
        await _peersSubscriptions?.cancel();

        _peersSubscriptions = _nearbyService.getPeersStream().listen((devices) {
          _peersController.add(devices);
        });
      }
    } on NearbyServiceException catch (e) {
      handleConnectivityException(e);
    }
  }

  @override
  Future<void> stopDiscovery() async {
    try {
      await _nearbyService.stopDiscovery();
      await _peersSubscriptions?.cancel();

      _peersSubscriptions = null;
      _peersController.add([]);
    } on NearbyServiceException catch (e) {
      handleConnectivityException(e);
    }
  }

  @override
  Future<void> dispose() async {
    await stopDiscovery();
    await _peersController.close();
  }
}
