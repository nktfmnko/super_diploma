import 'package:file_picker/file_picker.dart';

abstract interface class IDataPicker {
  Future<List<PlatformFile>?> pickFiles();
}
