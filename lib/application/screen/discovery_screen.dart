import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_diploma/application/ui_utils/snackbar_utils.dart';
import 'package:super_diploma/application/widget/custom_switch.dart';
import 'package:super_diploma/application/widget/device_search_list.dart';
import 'package:super_diploma/domain/errors/connectivity_exception.dart';
import 'package:super_diploma/domain/repository/nearby_discovery_service.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final _discoveryService = GetIt.I<INearbyDiscoveryService>();
  bool _isSearchEnabled = false;

  Future<void> _startDiscovery() async {
    try {
      await _discoveryService.startDiscovery();
    } on ConnectivityException catch (e) {
      showErrorSnackBar(e.message, context);
      rethrow;
    } on Exception {
      showErrorSnackBar('Что-то пошло не так', context);
      rethrow;
    }
  }

  Future<void> _stopDiscovery() async {
    try {
      await _discoveryService.stopDiscovery();
    } on ConnectivityException catch (e) {
      showErrorSnackBar(e.message, context);
      rethrow;
    } on Exception {
      showErrorSnackBar('Что-то пошло не так', context);
      rethrow;
    }
  }

  @override
  void dispose() {
    try {
      _discoveryService.dispose();
    } on ConnectivityException catch (e) {
      showErrorSnackBar(e.message, context);
    } on Exception {
      showErrorSnackBar('Что-то пошло не так.', context);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  Text(
                    'Поиск устройств',
                    style: TextStyle(fontSize: 20, fontWeight: .bold),
                  ),
                  CustomSwitch(
                    value: _isSearchEnabled,
                    onMethod: _startDiscovery,
                    offMethod: _stopDiscovery,
                    onChanged: (newValue) {
                      _isSearchEnabled = newValue;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            _isSearchEnabled
                ? Expanded(
                    child: DeviceSearchList(
                      peersStream: _discoveryService.peersStream,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
