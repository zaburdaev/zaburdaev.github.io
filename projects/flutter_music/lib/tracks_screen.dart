import 'package:flutter/material.dart';
import 'models/category_item.dart';
import 'l10n.dart';
import './player_screen.dart';  // измени на это

class TracksScreen extends StatelessWidget {
  final CategoryItem category;

  const TracksScreen({super.key, required this.category});

  List<Map<String, String>> getMockTracks(String categoryId, AppLocalizations loc) {
    // Для всех категорий одинаковый список с рабочими обложками Unsplash
    return [
      {
        'title': 'Lo-fi Chill',
        'artist': 'DJ Relax',
        'cover': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308',
        'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      },
      {
        'title': 'Night Coding',
        'artist': 'LoFi Beats',
        'cover': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      },
      {
        'title': 'Ambient Flow',
        'artist': 'Atmos',
        'cover': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
        'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      },
      {
        'title': 'Space Dreams',
        'artist': 'Dreamer',
        'cover': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
        'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      },
      {
        'title': 'Nature Walk',
        'artist': 'Green Sound',
        'cover': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
        'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      },
      {
        'title': 'Rainy Mood',
        'artist': 'Rainy',
        'cover': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308',
        'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final tracks = getMockTracks(category.id, loc);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.categoryTitle(category.id)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemCount: tracks.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final track = tracks[index];
          return ListTile(
            leading: (track['cover'] != null && track['cover']!.isNotEmpty)
                ? CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade200,
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
                    backgroundColor: Colors.deepPurple.shade200,
                    child: const Icon(Icons.music_note, color: Colors.white),
                  ),
            title: Text(
              track['title'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(track['artist'] ?? ''),
            trailing: IconButton(
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
                );
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
              );
            },
          );
        },
      ),
    );
  }
}