import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'dart:async';
import 'audio_player_handler.dart';

class PlayerScreen extends StatefulWidget {
  final List<Map<String, String>> tracks;
  final int initialIndex;

  const PlayerScreen({
    super.key,
    required this.tracks,
    this.initialIndex = 0,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  MyAudioHandler? _audioHandler;
  bool _isPlaying = false;
  int _currentIndex = 0;
  bool _isLoading = true;
  String? _error;
  StreamSubscription? _playerStateSub;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _initAudioHandler();
  }

  Future<void> _initAudioHandler() async {
    try {
      _audioHandler = await getAudioHandler();

      final mediaItems = widget.tracks.map((track) => MediaItem(
        id: track['url']!,
        album: '',
        title: track['title'] ?? '',
        artist: track['artist'] ?? '',
        artUri: (track['cover'] != null && track['cover']!.isNotEmpty)
            ? Uri.parse(track['cover']!)
            : null,
        duration: null,
      )).toList();

      await _audioHandler!.updateQueue(mediaItems);

      _playerStateSub = _audioHandler!.playerStateStream.listen((state) {
        if (!mounted) return;
        setState(() {
          _isPlaying = state.playing;
        });
      });

      _audioHandler!.positionStream.listen((pos) {
        if (!mounted) return;
        setState(() {
          _position = pos;
        });
      });
      _audioHandler!.durationStream.listen((dur) {
        if (!mounted) return;
        setState(() {
          _duration = dur ?? Duration.zero;
        });
      });

      setState(() {
        _isLoading = false;
      });

      await _audioHandler!.playMediaItem(mediaItems[_currentIndex]);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('Error initializing AudioHandler: $e');
    }
  }

  Future<void> _togglePlay() async {
    if (_audioHandler == null) return;

    try {
      if (!_isPlaying) {
        await _audioHandler!.play();
      } else {
        await _audioHandler!.pause();
      }
    } catch (e) {
      print('Error toggling play: $e');
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  Future<void> _playNext() async {
    if (_currentIndex < widget.tracks.length - 1) {
      setState(() {
        _currentIndex++;
      });
      final mediaItems = widget.tracks.map((track) => MediaItem(
        id: track['url']!,
        album: '',
        title: track['title'] ?? '',
        artist: track['artist'] ?? '',
        artUri: (track['cover'] != null && track['cover']!.isNotEmpty)
            ? Uri.parse(track['cover']!)
            : null,
        duration: null,
      )).toList();
      await _audioHandler!.playMediaItem(mediaItems[_currentIndex]);
    }
  }

  Future<void> _playPrevious() async {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      final mediaItems = widget.tracks.map((track) => MediaItem(
        id: track['url']!,
        album: '',
        title: track['title'] ?? '',
        artist: track['artist'] ?? '',
        artUri: (track['cover'] != null && track['cover']!.isNotEmpty)
            ? Uri.parse(track['cover']!)
            : null,
        duration: null,
      )).toList();
      await _audioHandler!.playMediaItem(mediaItems[_currentIndex]);
    }
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error: $_error'),
          ),
        ),
      );
    }

    final track = widget.tracks[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(track['title'] ?? 'Player'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (track['cover'] != null && track['cover']!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.network(
                track['cover']!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.music_note, size: 80),
                ),
              ),
            )
          else
            Container(
              width: 200,
              height: 200,
              color: Colors.grey.shade300,
              child: const Icon(Icons.music_note, size: 80),
            ),
          const SizedBox(height: 20),
          Text(
            track['title'] ?? '',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            track['artist'] ?? '',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          // Прогресс-бар
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1,
                  onChanged: (value) {
                    _audioHandler!.seek(Duration(seconds: value.toInt()));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_position)),
                    Text(_formatDuration(_duration)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: _currentIndex > 0 ? _playPrevious : null,
                iconSize: 36,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlay,
                iconSize: 48,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: _currentIndex < widget.tracks.length - 1 ? _playNext : null,
                iconSize: 36,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}