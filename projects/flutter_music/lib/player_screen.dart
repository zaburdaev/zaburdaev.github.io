import 'package:flutter/material.dart';
import 'l10n.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 80, color: Colors.deepPurple),
          const SizedBox(height: 20),
          Text(
            loc.get('player'),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isPlaying = !isPlaying;
              });
            },
            child: Text(isPlaying ? loc.get('pause') : loc.get('play')),
          ),
        ],
      ),
    );
  }
}