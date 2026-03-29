import 'package:mime/mime.dart';

enum FileCategory { image, video, pdf, audio, archive, unknown }

class FileTypeService {
  static FileCategory getCategory(String path) {
    final mimeType = lookupMimeType(path) ?? '';

    return switch (mimeType) {
      String m when m.startsWith('image/') => FileCategory.image,
      String m when m.startsWith('video/') => FileCategory.video,
      String m when m.startsWith('audio/') => FileCategory.audio,
      'application/pdf' => FileCategory.pdf,
      String m when m.contains('zip') || m.contains('rar') =>
        FileCategory.archive,
      _ => FileCategory.unknown,
    };
  }
}
