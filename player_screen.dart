import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'audio_player_handler.dart';

class PlayerScreen extends StatefulWidget {
  final List<Map<String, String>> tracks;
  final int initialIndex;

  const PlayerScreen({super.key, required this.tracks, this.initialIndex = 0});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  MyAudioHandler? _audioHandler;
  int _currentIndex = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _initAudio();
  }

  Future<void> _initAudio() async {
    print('initAudio: start');
    try {
      _audioHandler = await getAudioHandler();
      final queue = widget.tracks.map((track) => MediaItem(
        id: track['url']!,
        album: '',
        title: track['title']!,
        artist: track['artist']!,
        artUri: (track['cover'] != null && track['cover']!.isNotEmpty && track['cover']!.startsWith('http'))
            ? Uri.parse(track['cover']!)
            : null,
      )).toList();
      await _audioHandler!.updateQueue(queue);
      await _audioHandler!.playMediaItem(queue[_currentIndex]);
      setState(() {
        _isLoading = false;
        _error = null;
      });
      print('initAudio: end');
    } catch (e, stack) {
      print('initAudio ERROR: $e\n$stack');
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _playNext() {
    if (_audioHandler != null && _currentIndex < widget.tracks.length - 1) {
      _audioHandler!.skipToNext();
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _playPrev() {
    if (_audioHandler != null && _currentIndex > 0) {
      _audioHandler!.skipToPrevious();
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final track = widget.tracks[_currentIndex];
    if (_isLoading || _audioHandler == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ошибка')),
        body: Center(child: Text('Ошибка: $_error')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(track['title'] ?? '')),
      body: StreamBuilder<PlaybackState>(
        stream: _audioHandler!.playbackState,
        builder: (context, snapshot) {
          final state = snapshot.data;
          final playing = state?.playing ?? false;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if ((track['cover'] ?? '').isNotEmpty && (track['cover'] ?? '').startsWith('http'))
                Image.network(
                  track['cover']!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.music_note, size: 80, color: Colors.white),
                  ),
                )
              else
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.music_note, size: 80, color: Colors.white),
                ),
              const SizedBox(height: 20),
              Text(track['title'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(track['artist'] ?? '', style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.skip_previous), onPressed: _playPrev),
                  IconButton(
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                    iconSize: 48,
                    onPressed: () => playing ? _audioHandler!.pause() : _audioHandler!.play(),
                  ),
                  IconButton(icon: const Icon(Icons.skip_next), onPressed: _playNext),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}