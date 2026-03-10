import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_diploma/application/widget/custom_switch.dart';
import 'package:super_diploma/application/widget/device_search_list.dart';
import 'package:super_diploma/domain/repository/nearby_discovery_service.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final _discoveryService = GetIt.I<INearbyDiscoveryService>();
  bool _isSearchEnabled = false;

  void _showErrorSnackBar(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _startDiscovery() async {
    try {
      await _discoveryService.startDiscovery();
    } on NearbyDiscoveryServiceException catch (e) {
      _showErrorSnackBar(e.message);
      rethrow;
    } on Exception {
      _showErrorSnackBar('Что-то пошло не так');
      rethrow;
    }
  }

  Future<void> _stopDiscovery() async {
    try {
      await _discoveryService.stopDiscovery();
    } on NearbyDiscoveryServiceException catch (e) {
      _showErrorSnackBar(e.message);
      rethrow;
    } on Exception {
      _showErrorSnackBar('Что-то пошло не так');
      rethrow;
    }
  }

  @override
  void dispose() {
    try {
      _discoveryService.dispose();
    } on NearbyDiscoveryServiceException catch (e) {
      _showErrorSnackBar(e.message);
    } on Exception {
      _showErrorSnackBar('Что-то пошло не так.');
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
