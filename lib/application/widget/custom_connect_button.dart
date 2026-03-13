import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/application/controllers/connection_controller.dart';
import 'package:super_diploma/application/ui_utils/snackbar_utils.dart';
import 'package:super_diploma/domain/errors/connectivity_exception.dart';
import 'package:super_diploma/domain/repository/nearby_connection_service.dart';

import 'custom_button.dart';

class CustomConnectButton extends StatelessWidget {
  final NearbyDevice device;

  CustomConnectButton({super.key, required this.device});

  final _connectionService = GetIt.I<INearbyConnectionService>();

  late final ConnectionController _controller = ConnectionController(
    connectionService: _connectionService,
    device: device,
  );

  void _handleConnect(BuildContext context) async {
    try {
      await _controller.handleAction();
    } on ConnectivityException catch (e) {
      showErrorSnackBar(e.message, context);
    } on Exception {
      showErrorSnackBar('Что-то пошло не так', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (_, _) {
        return Column(
          mainAxisAlignment: .center,
          children: [
            _controller.status.isLoading
                ? CircularProgressIndicator()
                : Row(
                    children: [
                      _controller.status == ConnectionStatus.connected
                          ? CustomButton(name: 'В чат')
                          : SizedBox.shrink(),
                      Padding(
                        padding: const .only(left: 5),
                        child: CustomButton(
                          onPressed: () => _handleConnect(context),
                          name: _controller.status.buttonText,
                        ),
                      ),
                    ],
                  ),
          ],
        );
      },
    );
  }
}
