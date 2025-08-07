import 'package:ai_notes_app/models/note.dart';
import 'package:ai_notes_app/services/ai_service.dart';
import 'package:ai_notes_app/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;
  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final AiService _aiService = AiService();
  final SpeechToText _speechToText = SpeechToText();
  bool _isLoading = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) {
      if (widget.note?.id != null) {
        _firestoreService.deleteNote(widget.note!.id!);
      }
      return;
    }
    if (widget.note == null) {
      _firestoreService.addNote(title, content);
    } else {
      _firestoreService.updateNote(widget.note!.id!, title, content);
    }
  }

  void _toggleListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) => setState(() {
            _contentController.text += ' ${result.recognizedWords}';
          }),
        );
      }
    }
  }
  
  void _runAiFeature(Future<String> Function(String) feature) async {
    if (_contentController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    final result = await feature(_contentController.text);
    _contentController.text = result;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => _saveNote(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.auto_awesome, color: Colors.yellow),
              onSelected: (value) {
                if (value == 'summarize') _runAiFeature(_aiService.summarizeText);
                if (value == 'professional') _runAiFeature(_aiService.makeProfessional);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'summarize', child: Text('Summarize')),
                const PopupMenuItem(value: 'professional', child: Text('Make Professional')),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration.collapsed(hintText: 'Title'),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration.collapsed(hintText: 'Start writing...'),
                      maxLines: null,
                      expands: true,
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleListening,
          backgroundColor: _isListening ? Colors.red : Colors.yellow[700],
          child: Icon(_isListening ? Icons.mic_off : Icons.mic),
        ),
      ),
    );
  }
}