import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:nearby_service/nearby_service.dart';

class NearbyMessageConverter
    extends TypeConverter<ReceivedNearbyMessage, String> {
  @override
  ReceivedNearbyMessage<NearbyMessageContent> fromSql(String fromDb) {
    final Map<String, dynamic> data = jsonDecode(fromDb);
    return ReceivedNearbyMessage.fromJson(data);
  }

  @override
  String toSql(ReceivedNearbyMessage<NearbyMessageContent> value) {
    return jsonEncode(value.toJson());
  }
}
