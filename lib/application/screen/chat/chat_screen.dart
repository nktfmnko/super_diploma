import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/application/controllers/messaging_controller.dart';
import 'package:super_diploma/application/screen/chat/widgets/custom_popup_button.dart';
import 'package:super_diploma/application/screen/chat/widgets/custom_text_form_field.dart';
import 'package:super_diploma/application/screen/chat/widgets/messages_list.dart';

class ChatScreen extends StatefulWidget {
  final NearbyDevice device;

  const ChatScreen({super.key, required this.device});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final MessagingController _messagingController;
  StreamSubscription? _fileSubscription;

  @override
  void initState() {
    _messagingController = MessagingController(widget.device);
    _fileSubscription = _messagingController.fileRequestStream.listen((
      request,
    ) {
      if (!mounted) return;
      _showFilePickerSnackbar(request);
    });

    super.initState();
  }

  @override
  void dispose() {
    _messagingController.dispose();
    _fileSubscription?.cancel();
    super.dispose();
  }

  void _showFilePickerSnackbar(NearbyMessageFilesRequest request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ConstrainedBox(
          constraints: .loose(
            .fromHeight(MediaQuery.of(context).size.height * 0.10),
          ),
          child: SingleChildScrollView(
            child: Text(
              'Пользователь хочет отправить ${request.files.length} файл(ов):\n${request.files.map((e) => e.name).join('\n')}',
            ),
          ),
        ),
        action: SnackBarAction(
          label: 'Принять',
          onPressed: () {
            _messagingController.respondToFileRequest(request, true);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ScaffoldMessenger.of(context).clearSnackBars();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black26,
          title: Text(widget.device.info.displayName, overflow: .fade),
          actions: [
            CustomPopupButton(
              chatId: widget.device.info.id,
              controller: _messagingController,
            ),
          ],
        ),
        body: SafeArea(
          child: ListenableBuilder(
            listenable: _messagingController,
            builder: (_, _) {
              return Column(
                children: [
                  Expanded(
                    child: MessagesList(
                      messages: _messagingController.dbMessages,
                      loadMore: _messagingController.loadMore,
                      isLoading: _messagingController.isLoadingMore,
                    ),
                  ),
                  CustomTextFormField(
                    onSend: _messagingController.sendText,
                    currentState: _messagingController.state,
                    onAttachFiles: _messagingController.sendFiles,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
