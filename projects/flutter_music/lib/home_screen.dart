import 'package:flutter/material.dart';
import 'player_screen.dart';
import 'pomodoro_screen.dart';
import 'l10n.dart';

class HomeScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;
  const HomeScreen({super.key, required this.onLocaleChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    PlayerScreen(),
    PomodoroScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.get('app_title')),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'en') {
                widget.onLocaleChange(const Locale('en'));
              } else if (value == 'uk') {
                widget.onLocaleChange(const Locale('uk'));
              }
            },
            icon: const Icon(Icons.language),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'en',
                child: Text('English'),
              ),
              const PopupMenuItem(
                value: 'uk',
                child: Text('Українська'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              loc.get('developed_by'),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.music_note),
            label: loc.get('player'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.timer),
            label: loc.get('pomodoro'),
          ),
        ],
      ),
    );
  }
}