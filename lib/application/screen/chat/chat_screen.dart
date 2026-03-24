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

  @override
  void initState() {
    _messagingController = MessagingController(widget.device);
    super.initState();
  }

  @override
  void dispose() {
    _messagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
