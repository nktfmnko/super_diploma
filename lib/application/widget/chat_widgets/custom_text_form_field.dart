import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/application/controllers/messaging_controller.dart';

class CustomTextFormField extends StatefulWidget {
  final Future<void> Function(String message) onSend;
  final CommunicationChannelState currentState;

  const CustomTextFormField({
    super.key,
    required this.onSend,
    required this.currentState,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _handleSend() async {
    if (_controller.text.trim().isEmpty) return;
    await widget.onSend(_controller.text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .all(8),
      child: widget.currentState.isWaiting
          ? Text(widget.currentState.buttonText)
          : Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    keyboardType: .multiline,
                    decoration: InputDecoration(
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _controller,
                        builder: (_, value, _) {
                          final isEmpty = value.text.trim().isEmpty;
                          return IconButton(
                            onPressed: isEmpty ? null : _handleSend,
                            icon: const Icon(Icons.send),
                            color: Colors.blue,
                          );
                        },
                      ),
                      hintText: 'Введите сообщение',
                      border: OutlineInputBorder(
                        borderRadius: .all(.circular(20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
