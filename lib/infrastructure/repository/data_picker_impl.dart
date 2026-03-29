import 'package:file_picker/file_picker.dart';
import 'package:super_diploma/domain/repository/data_picker.dart';

class DataPicker implements IDataPicker {
  @override
  Future<List<PlatformFile>?> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    return result?.files;
  }
}
