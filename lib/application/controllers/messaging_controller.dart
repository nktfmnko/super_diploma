import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_diploma/domain/chat_message_entity.dart';
import 'package:super_diploma/domain/repository/nearby_messaging_service.dart';
import 'package:super_diploma/infrastructure/datasources/daos/messages_dao.dart';
import 'package:super_diploma/infrastructure/repository/data_picker_impl.dart';

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
  final NearbyDeviceInfo _deviceInfo;
  final bool isReadOnly;

  MessagingController(this._deviceInfo, {this.isReadOnly = false}) {
    _subscribeToDatabase();
    if (!isReadOnly) {
      connect();
      _subscribeToStatus();
      _subscribeToMessages();
      _subscribeToFiles();
    }
  }

  final _messagingService = GetIt.I<INearbyMessagingService>();
  final _messageDao = GetIt.I<MessagesDao>();
  final _filesPiker = DataPicker();

  StreamSubscription<CommunicationChannelState>? _communicationStatus;
  StreamSubscription<ReceivedNearbyMessage>? _messageSubscription;
  StreamSubscription<void>? _filesSubscription;

  final _fileRequestEventController =
      StreamController<NearbyMessageFilesRequest>.broadcast();

  Stream<NearbyMessageFilesRequest> get fileRequestStream =>
      _fileRequestEventController.stream;

  CommunicationChannelState _state = CommunicationChannelState.notConnected;

  CommunicationChannelState get state => _state;

  List<ChatMessageEntity> _dbMessages = [];

  List<ChatMessageEntity> get dbMessages => _dbMessages;
  StreamSubscription? _dbSubscription;

  int _currentMessageLimit = 20;
  bool _hasReachedMax = false;
  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  void _subscribeToDatabase() {
    _dbSubscription?.cancel();
    _dbSubscription = _messageDao
        .watchMessagesByChatId(_deviceInfo.id, limit: _currentMessageLimit)
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
        message.content.byType(
          onTextRequest: (request) async {
            await _messageDao.insertMessage(message, _deviceInfo);
            debugPrint(request.value);
          },
          onTextResponse: (response) {
            debugPrint('Наше сообщение ${response.id} было успешно доставлено');
          },
          onFilesRequest: (request) {
            _fileRequestEventController.add(request);
            debugPrint('Получен запрос на файлы: ${request.id}');
          },
          onFilesResponse: (response) {
            print('Получили ответ в ${DateTime.now()}');
          },
        );
      },
      onError: (e) {
        debugPrint('Ошибка в стриме: $e');
      },
    );
  }

  void _subscribeToFiles() {
    _filesSubscription = _messagingService.filesStream
        .asyncMap((pack) {
          _saveFiles(pack);
        })
        .listen((_) {
          debugPrint('обработали');
        });
  }

  Future<void> _saveFiles(ReceivedNearbyFilesPack pack) async {
    final directory = await getApplicationDocumentsDirectory();

    final tasks = pack.files.map((nearbyFile) async {
      final newPath =
          '${directory.path}/${DateTime.now().microsecondsSinceEpoch}.${nearbyFile.extension}';
      try {
        final file = await File(nearbyFile.path).rename(newPath);

        return {'path': file.path, 'size': file.lengthSync()};
      } catch (e) {
        final file = await File(nearbyFile.path).copy(newPath);
        return {'path': file.path, 'size': file.lengthSync()};
      }
    });

    final results = await Future.wait(tasks);

    await _messageDao.transaction(() async {
      for (final res in results) {
        print('Обработан файл: ${res['path']}, Размер: ${res['size']} байт, ${DateTime.now()}');
        await _messageDao.insertFileMessage(
          pathToFile: res['path'].toString(),
          sender: _deviceInfo,
          deviceInfo: _deviceInfo,
        );
        print('Файл записан, ${DateTime.now()}');
      }
    });
    // for (final nearbyFile in pack.files) {
    //   final file = await File(nearbyFile.path).rename(
    //     '${directory.path}/${DateTime.now().microsecondsSinceEpoch}.${nearbyFile.extension}',
    //   );
    //   print(
    //     'Получили в ${DateTime.now()}, Размер файла:${file.lengthSync()}байт',
    //   );
    //   await _messageDao.insertFileMessage(
    //     pathToFile: file.path,
    //     sender: _deviceInfo,
    //     deviceInfo: _deviceInfo,
    //   );
    // }
  }

  Future<void> connect() async {
    await _messagingService.startCommunication(_deviceInfo.id);
  }

  Future<void> disconnect() async {
    await _messagingService.stopCommunication();
  }

  Future<void> sendText(String text) async {
    final request = NearbyMessageTextRequest.create(value: text);

    await _messagingService.sendMessage(
      content: request,
      receiver: _deviceInfo,
    );

    final myMessage = ReceivedNearbyMessage(
      content: request,
      sender: NearbyDeviceInfo(displayName: 'Я', id: 'me'),
    );
    await _messageDao.insertMessage(myMessage, _deviceInfo);
  }

  Future<void> sendFiles() async {
    final files = await _filesPiker.pickFiles();
    if (files == null) return;

    final request = NearbyMessageFilesRequest.create(
      files: files.map((e) => NearbyFileInfo(path: e.path!)).toList(),
    );

    await _messagingService.sendMessage(
      content: request,
      receiver: _deviceInfo,
    );

    for (final file in request.files) {
      await _messageDao.insertFileMessage(
        pathToFile: file.path,
        sender: NearbyDeviceInfo(displayName: 'Я', id: 'me'),
        deviceInfo: _deviceInfo,
      );
    }
  }

  Future<void> respondToFileRequest(
    NearbyMessageFilesRequest request,
    bool accept,
  ) async {
    await _messagingService.sendMessage(
      content: NearbyMessageFilesResponse(id: request.id, isAccepted: accept),
      receiver: _deviceInfo,
    );
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

  Future<List<ChatMessageEntity>> searchMessage(String query) async {
    return await _messageDao.searchMessages(_deviceInfo.id, query);
  }

  @override
  void dispose() {
    _dbSubscription?.cancel();
    _fileRequestEventController.close();

    if (!isReadOnly) {
      _communicationStatus?.cancel();
      _messageSubscription?.cancel();
      _filesSubscription?.cancel();
      disconnect();
    }
    super.dispose();
  }
}
