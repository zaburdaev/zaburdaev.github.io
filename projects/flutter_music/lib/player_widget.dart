import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayerWidget extends StatefulWidget {
  final String trackTitle;
  final String artistName;
  final String trackUrl;
  final String coverUrl; // Новый параметр для обложки

  const PlayerWidget({
    super.key,
    required this.trackTitle,
    required this.artistName,
    required this.trackUrl,
    this.coverUrl = '',
  });

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer.setSourceUrl(widget.trackUrl);

    audioPlayer.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });
    audioPlayer.onPositionChanged.listen((p) {
      setState(() => position = p);
    });
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.resume();
    }
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Обложка трека или иконка
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
                image: widget.coverUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(widget.coverUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: widget.coverUrl.isEmpty
                  ? const Icon(Icons.music_note, size: 80, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 20),
            // Название трека
            Text(
              widget.trackTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Имя исполнителя
            Text(
              widget.artistName,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Прогресс-бар
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
              onChanged: (value) async {
                final newPosition = Duration(seconds: value.toInt());
                await audioPlayer.seek(newPosition);
              },
            ),
            // Время
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Кнопки управления
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {
                    // TODO: Реализовать переход к предыдущему треку
                  },
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: togglePlayPause,
                  iconSize: 48,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {
                    // TODO: Реализовать переход к следующему треку
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}