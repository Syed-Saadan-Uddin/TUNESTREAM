import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/song_model.dart';

class GeminiRepository {
  late final GenerativeModel _model;

  GeminiRepository() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  Future<String> getChatResponse(String query, Song? currentSong) async {
    try {
      String prompt;
      if (currentSong != null) {
        prompt = "You are a friendly and knowledgeable music assistant named 'Tune Stream'. The user is currently listening to '${currentSong.name}' by '${currentSong.artists.join(', ')}'. Answer their question concisely. User's question: '$query'";
      } else {
        prompt = "You are a friendly and knowledgeable music assistant named 'Tune Stream'. Answer the user's question concisely. User's question: '$query'";
      }
      
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? "Sorry, I couldn't process that.";
    } catch (e) {
      print("Gemini Error: $e");
      return "Sorry, I'm having trouble connecting right now.";
    }
  }
}