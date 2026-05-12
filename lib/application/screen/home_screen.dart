import 'package:flutter/material.dart';
import 'package:super_diploma/application/screen/chat_history/chat_history_screen.dart';
import 'package:super_diploma/application/screen/discovery/discovery_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _currentPageIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentPageIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _currentPageIndex,
          builder: (_, index, _) {
            return IndexedStack(
              index: index,
              children: [DiscoveryScreen(), ChatHistoryScreen()],
            );
          },
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _currentPageIndex,
        builder: (_, value, _) {
          return NavigationBar(
            onDestinationSelected: (int index) =>
                _currentPageIndex.value = index,
            selectedIndex: value,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.people_outline),
                selectedIcon: const Icon(Icons.people),
                label: 'Пиры',
              ),
              NavigationDestination(
                icon: const Icon(Icons.history_outlined),
                selectedIcon: const Icon(Icons.history),
                label: 'История',
              ),
            ],
          );
        },
      ),
    );
  }
}
