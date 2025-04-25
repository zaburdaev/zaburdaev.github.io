import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/audio_item.dart';

class FMAService {
  static const String _baseUrl = 'https://freemusicarchive.org/api/get';
  static const String _apiKey = 'YOUR_API_KEY'; // Получи ключ на freemusicarchive.org

  Future<List<AudioItem>> fetchLofiTracks() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/tracks.json?genre_handle=lo-fi&limit=20&api_key=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['dataset'] as List)
            .map((track) => AudioItem.fromFMA(track))
            .toList();
      } else {
        throw Exception('Failed to load tracks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tracks: $e');
      // Возвращаем тестовые данные если API недоступен
      return _getFallbackTracks();
    }
  }

  // Резервные треки если API недоступен
  List<AudioItem> _getFallbackTracks() {
  return [
    AudioItem(
      id: 'test',
      title: 'Test MP3',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      category: 'Test',
      author: 'SoundHelix',
      imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
    ),
  ];
}
} //