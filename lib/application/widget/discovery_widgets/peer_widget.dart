import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/application/widget/discovery_widgets/custom_connect_button.dart';

class PeerWidget extends StatelessWidget {
  final NearbyDevice device;

  const PeerWidget({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Icon(Icons.account_circle, size: 40),
          Text(device.info.displayName),
          Padding(
            padding: .only(left: 10),
            child: CustomConnectButton(
              device: device,
              key: ValueKey(device.info.id),
            ),
          ),
        ],
      ),
    );
  }
}
