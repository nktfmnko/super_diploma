import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/application/screen/discovery/widgets/peer_widget.dart';

class DeviceSearchList extends StatelessWidget {
  final Stream<List<NearbyDevice>> peersStream;

  const DeviceSearchList({super.key, required this.peersStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NearbyDevice>>(
      stream: peersStream,
      initialData: [],
      builder: (_, snapshot) {
        final devices = snapshot.data ?? [];
        if (devices.isEmpty) {
          return Align(
            alignment: .topCenter,
            child: const CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: devices.length,
          itemBuilder: (_, index) {
            final device = devices[index];
            return PeerWidget(device: device);
          },
        );
      },
    );
  }
}
