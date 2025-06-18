import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Playlist extends Equatable {
  final String id;
  final String name;
  final List<String> songIds;
  final String? coverUrl; 

  const Playlist({
    required this.id,
    required this.name,
    required this.songIds,
    this.coverUrl,
  });

  static Playlist fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return Playlist(
      id: snap.id,
      name: data['name'] ?? 'Unnamed Playlist',
      songIds: List<String>.from(data['songIds'] ?? []),
      coverUrl: data['coverUrl'],
    );
  }
  
  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'songIds': songIds,
      'coverUrl': coverUrl,
    };
  }

  @override
  List<Object?> get props => [id, name, songIds, coverUrl];
}