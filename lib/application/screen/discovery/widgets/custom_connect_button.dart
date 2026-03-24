import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/application/controllers/connection_controller.dart';
import 'package:super_diploma/application/screen/chat/chat_screen.dart';
import 'package:super_diploma/application/ui_utils/snackbar_utils.dart';
import 'package:super_diploma/domain/errors/connectivity_exception.dart';

import '../../../widget/custom_button.dart';

class CustomConnectButton extends StatefulWidget {
  final NearbyDevice device;

  const CustomConnectButton({super.key, required this.device});

  @override
  State<CustomConnectButton> createState() => _CustomConnectButtonState();
}

class _CustomConnectButtonState extends State<CustomConnectButton> {
  late final ConnectionController _controller;

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
  void initState() {
    super.initState();
    _controller = ConnectionController(device: widget.device);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                      if (_controller.status == ConnectionStatus.connected)
                          CustomButton(
                              name: 'В чат',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ChatScreen(device: widget.device),
                                  ),
                                );
                              },
                            ),
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
