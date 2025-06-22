import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class ApiService {
  static const String _baseUrl =
      'https://cors-anywhere.herokuapp.com/https://www.mmobomb.com/api1';

  Future<List<Game>> fetchGames({int retryCount = 3}) async {
    for (int attempt = 1; attempt <= retryCount; attempt++) {
      try {
        final response = await http.get(Uri.parse('$_baseUrl/games'));

        print('API Response Status: ${response.statusCode}');
        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body);
          return jsonResponse.map((data) => Game.fromJson(data)).toList();
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Attempt $attempt failed: $e');
        if (attempt == retryCount) rethrow;
        await Future.delayed(Duration(seconds: attempt)); // Exponential backoff
      }
    }
    throw Exception('Failed to load games after retries');
  }
}
