import 'package:nearby_service/nearby_service.dart';

abstract interface class INearbyDiscoveryService {
  Future<void> startDiscovery();

  Future<void> stopDiscovery();

  Stream<List<NearbyDevice>> get peersStream;
}
