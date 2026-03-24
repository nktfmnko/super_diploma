import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/domain/repository/nearby_messaging_service.dart';
import 'package:super_diploma/infrastructure/datasources/daos/messages_dao.dart';

extension CommunicationChannelStateX on CommunicationChannelState {
  String get buttonText {
    switch (this) {
      case CommunicationChannelState.notConnected:
        return 'Ждем другого пользователя';
      case CommunicationChannelState.loading:
        return 'Пользователь подключается...';
      case CommunicationChannelState.connected:
        return 'Подключились';
    }
  }

  bool get isWaiting =>
      this == CommunicationChannelState.notConnected ||
      this == CommunicationChannelState.loading;
}

class MessagingController extends ChangeNotifier {
  final NearbyDevice _device;

  MessagingController(this._device) {
    connect();
    _subscribeToDatabase();
    _subscribeToStatus();
    _subscribeToMessages();
  }

  final _messagingService = GetIt.I<INearbyMessagingService>();
  final _messageDao = GetIt.I<MessagesDao>();

  StreamSubscription<CommunicationChannelState>? _communicationStatus;
  StreamSubscription<ReceivedNearbyMessage>? _messageSubscription;
  StreamSubscription<ReceivedNearbyFilesPack>? _filesSubscription;

  CommunicationChannelState _state = CommunicationChannelState.notConnected;

  CommunicationChannelState get state => _state;

  List<ReceivedNearbyMessage> _dbMessages = [];

  List<ReceivedNearbyMessage> get dbMessages => _dbMessages;
  StreamSubscription? _dbSubscription;

  int _currentMessageLimit = 20;
  bool _hasReachedMax = false;
  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  void _subscribeToDatabase() {
    _dbSubscription?.cancel();
    _dbSubscription = _messageDao
        .watchMessagesByChatId(_device.info.id, limit: _currentMessageLimit)
        .listen((data) {
          _dbMessages = data;
          _hasReachedMax = data.length < _currentMessageLimit;
          notifyListeners();
        });
  }

  void loadMore() async {
    if (_hasReachedMax || _isLoadingMore) return;
    _isLoadingMore = true;
    notifyListeners();

    _currentMessageLimit += 20;

    await Future.delayed(const Duration(milliseconds: 100));
    _isLoadingMore = false;
    _subscribeToDatabase();

    notifyListeners();
  }

  void _subscribeToStatus() {
    _communicationStatus = _messagingService.channelStateStream.listen(
      (newStatus) {
        debugPrint(newStatus.toString());
        _updateStatus(newStatus);
      },
      onError: (e) {
        debugPrint('Ошибка в стриме: $e');
      },
    );
  }

  void _subscribeToMessages() {
    _messageSubscription = _messagingService.messagesStream.listen(
      (message) {
        _messageDao.insertMessage(message, _device.info.id);

        message.content.byType(
          onTextRequest: (request) {
            //_sendAutoResponse(message.sender, request.id);
            debugPrint(request.value);
          },
          onTextResponse: (response) {
            debugPrint('Наше сообщение ${response.id} было успешно доставлено');
          },
        );
      },
      onError: (e) {
        debugPrint('Ошибка в стриме: $e');
      },
    );
  }

  void _subscribeToFiles() {
    _filesSubscription = _messagingService.filesStream.listen((pack) {
      debugPrint('файл');
    });
  }

  Future<void> connect() async {
    await _messagingService.startCommunication(_device.info.id);
  }

  Future<void> disconnect() async {
    await _messagingService.stopCommunication();
  }

  Future<void> sendText(String text) async {
    final request = NearbyMessageTextRequest.create(value: text);

    await _messagingService.sendMessage(
      content: request,
      receiver: _device.info,
    );

    final myMessage = ReceivedNearbyMessage(
      content: request,
      sender: NearbyDeviceInfo(displayName: 'Я', id: 'me'),
    );
    _messageDao.insertMessage(myMessage, _device.info.id);
  }

  Future<void> _sendAutoResponse(
    NearbyDeviceInfo receiver,
    String requestId,
  ) async {
    await _messagingService.sendMessage(
      content: NearbyMessageTextResponse(id: requestId),
      receiver: receiver,
    );
  }

  void _updateStatus(CommunicationChannelState newStatus) {
    if (newStatus == _state) return;
    _state = newStatus;
    notifyListeners();
  }

  Future<void> deleteHistory(String chatId) async {
    await _messageDao.deleteHistory(chatId);
  }

  @override
  void dispose() {
    _communicationStatus?.cancel();
    _messageSubscription?.cancel();
    _filesSubscription?.cancel();
    _dbSubscription?.cancel();
    disconnect();
    super.dispose();
  }
}
