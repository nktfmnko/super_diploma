import 'package:flutter/material.dart';
import 'package:super_diploma/application/widget/custom_button.dart';

class PeerWidget extends StatelessWidget {
  final String deviceName;

  const PeerWidget({super.key, required this.deviceName});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Icon(Icons.account_circle, size: 40),
          Text(deviceName),
          Padding(
            padding: .only(left: 10),
            child: CustomButton(name: 'Подключиться', onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
