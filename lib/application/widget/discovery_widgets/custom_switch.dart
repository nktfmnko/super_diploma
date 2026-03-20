import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final Future<void> Function() onMethod;
  final Future<void> Function() offMethod;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.onMethod,
    required this.offMethod,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      activeThumbColor: Colors.blue,
      onChanged: (bool newValue) async {
        try {
          newValue ? await onMethod() : await offMethod();
          onChanged(newValue);
        } catch (e) {
          debugPrint("Ошибка в CustomSwitch: $e");
        }
      },
    );
  }
}
