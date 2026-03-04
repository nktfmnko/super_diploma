import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isOk;
  final VoidCallback onPressed;

  const StatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isOk,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isOk ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const .all(8.0),
        child: Row(
          children: [
            Icon(
              isOk ? Icons.check_circle : Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            if (!isOk)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextButton(
                  onPressed: onPressed,
                  child: const Text(
                    "Перейти в настройки",
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
