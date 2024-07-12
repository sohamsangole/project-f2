class Song {
  final String id;
  final String title;
  final String artist;
  final int duration;
  final int time;
  final String albumCover;
  final bool isPlaying;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.time,
    required this.albumCover,
    required this.isPlaying,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      duration: json['duration'],
      time: json['time'],
      albumCover: json['album_cover'],
      isPlaying: json['is_playing'],
    );
  }
}
