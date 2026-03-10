import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_diploma/application/widget/status_card.dart';
import 'package:super_diploma/domain/repository/device_status_service.dart';

class GetPermissionsScreen extends StatefulWidget {
  const GetPermissionsScreen({super.key});

  @override
  State<GetPermissionsScreen> createState() => _GetPermissionsScreenState();
}

class _GetPermissionsScreenState extends State<GetPermissionsScreen>
    with WidgetsBindingObserver {
  final _nearbyService = GetIt.I<NearbyService>();
  final _deviceStatus = GetIt.I<IDeviceStatusService>();

  bool _isWifiEnabled = false;
  bool _isPermissionsGranted = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _fullCheck();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fullCheck();
    }
  }

  Future<void> _fullCheck() async {
    final wifi = await _deviceStatus.checkWifiStatus();
    final perm = await _deviceStatus.checkPermissions();

    if (mounted) {
      _isWifiEnabled = wifi;
      _isPermissionsGranted = perm;
      setState(() {});

      if (wifi && perm) {
        Navigator.of(context).pushReplacementNamed('/discovery');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Text(
                'Нужны следующие разрешения:',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: .all(5),
                child: Column(
                  children: [
                    StatusCard(
                      title: 'Разрешения',
                      subtitle: 'Местоположение и устройства по близости',
                      isOk: _isPermissionsGranted,
                      onPressed: openAppSettings,
                    ),
                    SizedBox(height: 10),
                    StatusCard(
                      title: 'Wi-Fi',
                      subtitle: 'Должен быть включен',
                      isOk: _isWifiEnabled,
                      onPressed: _nearbyService.android!.openServicesSettings,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
