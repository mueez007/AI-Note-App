import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Get the current user's UID
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  // Get a stream of notes for the current user
  Stream<QuerySnapshot> getNotesStream() {
    if (_uid == null) throw Exception("User is not logged in");
    return _db.collection('users').doc(_uid).collection('notes').orderBy('date', descending: true).snapshots();
  }

  // Add a new note
  Future<void> addNote(String title, String content) {
    if (_uid == null) throw Exception("User is not logged in");
    return _db.collection('users').doc(_uid).collection('notes').add({
      'title': title.isEmpty ? "Untitled Note" : title,
      'content': content,
      'date': Timestamp.now(),
    });
  }

  // Update an existing note
  Future<void> updateNote(String docId, String title, String content) {
    if (_uid == null) throw Exception("User is not logged in");
    return _db.collection('users').doc(_uid).collection('notes').doc(docId).update({
      'title': title.isEmpty ? "Untitled Note" : title,
      'content': content,
      'date': Timestamp.now(),
    });
  }

  // Delete a note
  Future<void> deleteNote(String docId) {
    if (_uid == null) throw Exception("User is not logged in");
    return _db.collection('users').doc(_uid).collection('notes').doc(docId).delete();
  }
}