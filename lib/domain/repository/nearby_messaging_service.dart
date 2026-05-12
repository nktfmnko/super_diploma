import 'package:nearby_service/nearby_service.dart';

abstract interface class INearbyMessagingService {
  /// Метод инициализации канала связи с другим устройством.
  Future<void> startCommunication(String deviceId);

  /// Закрывает канал связи и освобождает ресурсы.
  Future<void> stopCommunication();

  /// Отправляет контент(текст, файл) на устройство.
  Future<void> sendMessage({
    required NearbyMessageContent content,
    required NearbyDeviceInfo receiver,
  });

  /// Поток состояния канала связи.
  Stream<CommunicationChannelState> get channelStateStream;

  /// Поток входящих сообщений.
  Stream<ReceivedNearbyMessage<NearbyMessageContent>> get messagesStream;

  /// Поток входящих файлов.
  Stream<ReceivedNearbyFilesPack> get filesStream;
}
