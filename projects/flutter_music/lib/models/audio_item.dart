class AudioItem {
  final String id;
  final String title;
  final String url;
  final String category;
  final String? imageUrl;
  final String? author;
  final int? duration;

  AudioItem({
    required this.id,
    required this.title,
    required this.url,
    required this.category,
    this.imageUrl,
    this.author,
    this.duration,
  });

  factory AudioItem.fromFMA(Map<String, dynamic> json) {
    return AudioItem(
      id: json['track_id'].toString(),
      title: json['track_title'] ?? 'Unknown',
      url: json['track_url'] ?? '',
      category: json['track_genres']?.first?['genre_title'] ?? 'Unknown',
      imageUrl: json['track_image_file'],
      author: json['artist_name'],
      duration: json['track_duration']?.toInt(),
    );
  }
}