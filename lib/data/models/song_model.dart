import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String name;
  final List<String> artists;
  final String album;
  final String coverUrl;
  final String songUrl;
  final int durationMs;
  final String genre;
  final int playCount;

  const Song({
    required this.id,
    required this.name,
    required this.artists,
    required this.album,
    required this.coverUrl,
    required this.songUrl,
    required this.durationMs,
    required this.genre,
    required this.playCount,
  });

  static Song fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return Song(
      id: snap.id,
      name: data['name'] ?? 'Unknown Title',
      artists: List<String>.from(data['artists'] ?? ['Unknown Artist']),
      album: data['album'] ?? 'Unknown Album',
      coverUrl: data['cover_url'] ?? '',
      songUrl: data['song_url'] ?? '',
      durationMs: data['duration_ms'] ?? 0,
      genre: data['genre'] ?? 'Misc',
      playCount: data['play_count'] ?? 0,
    );
  }
  
  @override
  List<Object?> get props => [id, name, artists, album, coverUrl, songUrl, durationMs, genre, playCount];
}