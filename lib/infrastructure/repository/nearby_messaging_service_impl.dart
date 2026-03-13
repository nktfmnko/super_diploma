import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/domain/errors/connectivity_exception.dart';
import 'package:super_diploma/domain/repository/nearby_messaging_service.dart';

class NearbyMessagingService implements INearbyMessagingService {
  final NearbyService _nearbyService;

  final _messagesController =
      StreamController<ReceivedNearbyMessage<NearbyMessageContent>>.broadcast();
  final _filesController =
      StreamController<ReceivedNearbyFilesPack>.broadcast();

  NearbyMessagingService(this._nearbyService);

  @override
  Stream<CommunicationChannelState> get channelStateStream =>
      _nearbyService.getCommunicationChannelStateStream();

  @override
  Stream<ReceivedNearbyFilesPack> get filesStream => _filesController.stream;

  @override
  Stream<ReceivedNearbyMessage<NearbyMessageContent>> get messagesStream =>
      _messagesController.stream;

  @override
  Future<void> sendMessage({
    required NearbyMessageContent content,
    required NearbyDeviceInfo receiver,
  }) async {
    await _nearbyService.send(
      OutgoingNearbyMessage(content: content, receiver: receiver),
    );
  }

  @override
  Future<void> startCommunication(String deviceId) async {
    _nearbyService.startCommunicationChannel(
      NearbyCommunicationChannelData(
        deviceId,
        messagesListener: NearbyServiceMessagesListener(
          onCreated: () {
            debugPrint('Канал связи успешно создан!');
          },
          onData: (message) => _messagesController.add(message),
          onDone: () {
            _messagesController.addError(
              'Соединение закрыто удаленным устройством',
            );
          },
          onError: (e, [StackTrace? s]) {
            if (e is NearbyServiceException) {
              try {
                handleConnectivityException(e);
              } catch (connectivityException) {
                _messagesController.addError(connectivityException);
              }
            } else {
              _messagesController.addError(
                'Произошла ошибка при передаче данных. Попробуйте еще раз',
              );
            }
          },
        ),
        filesListener: NearbyServiceFilesListener(
          onCreated: () {
            debugPrint('Канал связи успешно создан!');
          },
          onData: (pack) => _filesController.add(pack),
          onDone: () {
            _filesController.addError('Соединение закрыто другим устройством');
          },
          onError: (e, [StackTrace? s]) {
            if (e is NearbyServiceException) {
              try {
                handleConnectivityException(e);
              } catch (connectivityException) {
                _filesController.addError(connectivityException);
              }
            } else {
              _filesController.addError(
                'Произошла ошибка при передаче данных. Попробуйте еще раз',
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Future<void> stopCommunication() async {
    await _nearbyService.endCommunicationChannel();
  }

  void dispose() {
    _messagesController.close();
    _filesController.close();
  }
}
