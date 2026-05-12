import 'package:flutter/material.dart';
import 'package:nearby_service/nearby_service.dart';
import 'package:super_diploma/application/controllers/chat_history_controller.dart';
import 'package:super_diploma/application/screen/chat/chat_screen.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final _controller = ChatHistoryController();

  @override
  void initState() {
    _controller.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Все чаты:',
                style: TextStyle(fontSize: 20, fontWeight: .bold),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await _controller.getUsers();
                  },
                  child: ListenableBuilder(
                    listenable: _controller,
                    builder: (BuildContext context, Widget? child) {
                      if (_controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (_controller.users.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(
                              height: 500,
                              child: Center(child: Text('Нема')),
                            ),
                          ],
                        );
                      }

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _controller.users.length,
                        itemBuilder: (context, index) {
                          final user = _controller.users[index];
                          return ListTile(
                            leading: const Icon(Icons.account_circle, size: 40),
                            title: Text(user.deviceName),
                            trailing: const Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    deviceInfo: NearbyDeviceInfo(
                                      displayName: user.deviceName,
                                      id: user.deviceId,
                                    ),
                                    isReadOnly: true,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
