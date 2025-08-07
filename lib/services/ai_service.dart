import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  final GenerativeModel _model;

  AiService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: dotenv.env['GEMINI_API_KEY']!,
        );

  Future<String> _generateText(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Error: Could not generate text.';
    } catch (e) {
      return 'Error connecting to AI. Please check your connection or API key.';
    }
  }

  Future<String> summarizeText(String text) async {
    return _generateText('Summarize the following text:\n\n$text');
  }

  Future<String> makeProfessional(String text) async {
    return _generateText('Rewrite the following text to make it sound more professional:\n\n$text');
  }
}