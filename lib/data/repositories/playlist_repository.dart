import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/playlist_model.dart';

class PlaylistRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _uuid = const Uuid();

  String? get _userId => _auth.currentUser?.uid;

  Future<String> createPlaylist(String name, String? firstSongCoverUrl) async {
    final userId = _userId;
    if (userId == null) throw Exception('User not logged in');
    final playlistId = _uuid.v4();
    final newPlaylist = Playlist(
      id: playlistId,
      name: name,
      songIds: [],
      coverUrl: firstSongCoverUrl,
    );
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('playlists')
        .doc(playlistId)
        .set(newPlaylist.toDocument());
    return playlistId;
  }

  Future<List<Playlist>> fetchUserPlaylists() async {
    final userId = _userId;
    if (userId == null) return [];
    final snapshot = await _firestore.collection('users').doc(userId).collection('playlists').get();
    return snapshot.docs.map((doc) => Playlist.fromSnapshot(doc)).toList();
  }

  Future<void> addSongToPlaylist(String playlistId, String songId, String songCoverUrl) async {
    final userId = _userId;
    if (userId == null) throw Exception('User not logged in');
    final playlistRef = _firestore.collection('users').doc(userId).collection('playlists').doc(playlistId);
    final playlistDoc = await playlistRef.get();
    if (playlistDoc.exists && (playlistDoc.data()?['coverUrl'] == null || playlistDoc.data()?['coverUrl'] == '')) {
      await playlistRef.update({
        'songIds': FieldValue.arrayUnion([songId]),
        'coverUrl': songCoverUrl,
      });
    } else {
      await playlistRef.update({'songIds': FieldValue.arrayUnion([songId])});
    }
  }
  Future<void> deletePlaylist(String playlistId) async {
    final userId = _userId;
    if (userId == null) throw Exception('User not logged in');
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('playlists')
        .doc(playlistId)
        .delete();
  }
  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    final userId = _userId;
    if (userId == null) throw Exception('User not logged in');
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('playlists')
        .doc(playlistId)
        .update({'songIds': FieldValue.arrayRemove([songId])});
  }
  Future<void> likeSong(String songId) async {
    final userId = _userId;
    if (userId == null) throw Exception('User not logged in');
    await _firestore.collection('users').doc(userId).collection('liked_songs').doc(songId).set({'liked_at': Timestamp.now()});
  }

  Future<void> unlikeSong(String songId) async {
    final userId = _userId;
    if (userId == null) throw Exception('User not logged in');
    await _firestore.collection('users').doc(userId).collection('liked_songs').doc(songId).delete();
  }

  Future<Set<String>> fetchLikedSongIds() async {
    final userId = _userId;
    if (userId == null) return {};
    final snapshot = await _firestore.collection('users').doc(userId).collection('liked_songs').get();
    return snapshot.docs.map((doc) => doc.id).toSet();
  }
}