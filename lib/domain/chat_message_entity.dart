import 'package:nearby_service/nearby_service.dart';

class ChatMessageEntity {
  final ReceivedNearbyMessage<NearbyMessageContent> message;
  final String? pathToFile;
  final int id;

  ChatMessageEntity({required this.message, this.pathToFile, required this.id});
}
