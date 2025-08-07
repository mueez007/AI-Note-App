import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey;

  GeminiService(this.apiKey);

  final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/';

  Future<String> generateText(String prompt) async {
    final url = Uri.parse('$baseUrl' 'gemini-pro:generateContent?key=$apiKey');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'content': [
          {
            'text': prompt
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['text'] ?? '';
    } else {
      throw Exception('Failed to generate text: ${response.body}');
    }
  }

  Future<String> generateImage(String prompt) async {
    final url = Uri.parse('$baseUrl' 'imagen-4:generateImage?key=$apiKey');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prompt': prompt,
        'imageCount': 1,
        'size': '1024x1024',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['imageUrls'][0] ?? '';
    } else {
      throw Exception('Failed to generate image: ${response.body}');
    }
  }

  Future<String> generateVideo(String prompt) async {
    final url = Uri.parse('$baseUrl' 'veo-3:generateVideo?key=$apiKey');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prompt': prompt,
        'videoCount': 1,
        'resolution': '720p',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['videoUrls'][0] ?? '';
    } else {
      throw Exception('Failed to generate video: ${response.body}');
    }
  }
}
