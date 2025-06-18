import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/song_model.dart';

class SongRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String? get _userId => _auth.currentUser?.uid;

  Future<List<Song>> fetchAllSongs() async {
    try {
      final snapshot = await _firestore.collection('songs').get();
      return snapshot.docs.map((doc) => Song.fromSnapshot(doc)).toList();
    } catch (e) {
      print("Error fetching songs: $e");
      rethrow;
    }
  }

  Future<void> logSongPlay(Song song) async {
    final userId = _userId;
    if (userId == null) return;

    final historyRef = _firestore
        .collection('users').doc(userId)
        .collection('history').doc();

    await historyRef.set({
      'songId': song.id,
      'name': song.name,
      'artists': song.artists,
      'coverUrl': song.coverUrl,
      'played_at': FieldValue.serverTimestamp(),
    });

    final songRef = _firestore.collection('songs').doc(song.id);
    await songRef.update({'play_count': FieldValue.increment(1)});
  }

  Future<List<Map<String, dynamic>>> fetchUserHistory() async {
    final userId = _userId;
    if (userId == null) return [];
    
    final snapshot = await _firestore
        .collection('users').doc(userId)
        .collection('history')
        .orderBy('played_at', descending: true)
        .limit(50)
        .get();
        
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Song>> fetchTrendingSongs() async {
    final snapshot = await _firestore
        .collection('songs')
        .orderBy('play_count', descending: true)
        .limit(10)
        .get();
    return snapshot.docs.map((doc) => Song.fromSnapshot(doc)).toList();
  }
  
  
}