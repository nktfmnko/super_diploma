import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:super_diploma/application/screen/chat/widgets/messages_widgets/audio_player_widget.dart';
import 'package:super_diploma/application/screen/chat/widgets/messages_widgets/image_message_widget.dart';
import 'package:super_diploma/services/file_type_service.dart';

class FileMessageWidget extends StatelessWidget {
  final String filePath;

  const FileMessageWidget({super.key, required this.filePath});

  IconData _getIconForCategory(FileCategory type) {
    return switch (type) {
      FileCategory.video => Icons.video_file,
      FileCategory.pdf => Icons.picture_as_pdf,
      FileCategory.archive => Icons.archive,
      _ => Icons.insert_drive_file,
    };
  }

  @override
  Widget build(BuildContext context) {
    final file = File(filePath);
    final type = FileTypeService.getCategory(filePath);
    return switch (type) {
      FileCategory.image => ImageMessageWidget(imageFile: file),
      FileCategory.audio => AudioPlayerWidget(audio: filePath),

      FileCategory.video ||
      FileCategory.pdf ||
      FileCategory.archive ||
      FileCategory.unknown => GestureDetector(
        onTap: () async {
          await OpenFile.open(filePath);
        },
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(_getIconForCategory(type), color: Colors.white, size: 30),
            Flexible(
              child: Text(
                filePath.split('/').last,
                overflow: .ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    };
  }
}
