import 'package:ai_notes_app/models/note.dart';
import 'package:ai_notes_app/pages/note_editor_page.dart';
import 'package:ai_notes_app/services/auth_service.dart';
import 'package:ai_notes_app/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.black,
                expandedHeight: 120.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 45),
                  title: const Text('Notes', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  background: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestoreService.getNotesStream(),
                        builder: (context, snapshot) {
                          final noteCount = snapshot.data?.docs.length ?? 0;
                          return Text('$noteCount notes', style: TextStyle(color: Colors.grey[400]));
                        },
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(tooltip: 'Logout', icon: const Icon(Icons.logout), onPressed: () => _authService.signOut()),
                ],
                bottom: const TabBar(
                  indicatorColor: Colors.white,
                  tabs: [Tab(text: 'All notes'), Tab(text: 'Default notebook'), Tab(text: 'Recently')],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildNotesList(),
              const Center(child: Text('Default Notebook feature coming soon!')),
              const Center(child: Text('Recently feature coming soon!')),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NoteEditorPage())),
          backgroundColor: Colors.yellow[700],
          child: const Icon(Icons.add, color: Colors.black, size: 30),
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getNotesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No notes yet. Tap "+" to create one!'));
        }
        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: snapshot.data!.docs.map((doc) {
            final note = Note.fromFirestore(doc);
            return Card(
              color: Colors.grey[900],
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              child: ListTile(
                title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${DateFormat.yMMMd().format(note.date)} ${note.content}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoteEditorPage(note: note))),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}