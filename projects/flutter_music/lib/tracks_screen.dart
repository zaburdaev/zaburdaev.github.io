import 'package:flutter/material.dart';
import 'models/category_item.dart';
import 'l10n.dart';
import 'player_screen.dart';

class TracksScreen extends StatefulWidget {
  final CategoryItem category;
  final int? playingIndex; // добавлено

  const TracksScreen({super.key, required this.category, this.playingIndex});

  @override
  State<TracksScreen> createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen> {
  int? _playingIndex;

  List<Map<String, String>> getMockTracks(String categoryId, AppLocalizations loc) {
    return [
      {
        'title': 'Lo-fi Chill',
        'artist': 'DJ Relax',
        'cover': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308',
        'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      },
      // ... остальные треки
    ];
  }

  @override
  void initState() {
    super.initState();
    _playingIndex = widget.playingIndex;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final tracks = getMockTracks(widget.category.id, loc);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.categoryTitle(widget.category.id)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemCount: tracks.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final track = tracks[index];
          final isPlaying = index == _playingIndex;
          return ListTile(
            leading: (track['cover'] != null && track['cover']!.isNotEmpty)
                ? CircleAvatar(
                    backgroundColor: isPlaying ? Colors.green : Colors.deepPurple.shade200,
                    child: ClipOval(
                      child: Image.network(
                        track['cover']!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.music_note, color: Colors.white),
                      ),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: isPlaying ? Colors.green : Colors.deepPurple.shade200,
                    child: const Icon(Icons.music_note, color: Colors.white),
                  ),
            title: Text(
              track['title'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPlaying ? Colors.green : null,
              ),
            ),
            subtitle: Text(track['artist'] ?? ''),
            trailing: isPlaying
                ? const Icon(Icons.equalizer, color: Colors.green)
                : IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerScreen(
                            tracks: tracks,
                            initialIndex: index,
                          ),
                        ),
                      ).then((_) {
                        setState(() {
                          _playingIndex = index;
                        });
                      });
                    },
                  ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(
                    tracks: tracks,
                    initialIndex: index,
                  ),
                ),
              ).then((_) {
                setState(() {
                  _playingIndex = index;
                });
              });
            },
            selected: isPlaying,
          );
        },
      ),
    );
  }
}