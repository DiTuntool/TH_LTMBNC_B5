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
        print('Full URL: ${response.request?.url}');
        print('Response Body: ${response.body}');
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

  Future<GameDetail> fetchGameDetail(int id, {int retryCount = 3}) async {
    for (int attempt = 1; attempt <= retryCount; attempt++) {
      try {
        final response = await http.get(Uri.parse('$_baseUrl/game?id=$id'));
        print('Full URL: ${response.request?.url}');
        print('Response Body: ${response.body}');
        print('API Detail Response Status: ${response.statusCode}');
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          return GameDetail.fromJson(jsonResponse);
        } else {
          throw Exception('Failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Detail Attempt $attempt failed: $e');
        if (attempt == retryCount) rethrow;
        await Future.delayed(Duration(seconds: attempt)); // Exponential backoff
      }
    }
    throw Exception('Failed to load game details after retries');
  }

  Future<List<Game>> fetchGamesByPlatform(
    String platform, {
    int retryCount = 3,
  }) async {
    for (int attempt = 1; attempt <= retryCount; attempt++) {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/games?platform=$platform'),
        );
        print('Full URL: ${response.request?.url}');
        print('Response Body: ${response.body}');
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
    throw Exception('Failed to load games by platform after retries');
  }

  Future<List<Game>> fetchGamesByCategory(
    String category, {
    int retryCount = 3,
  }) async {
    for (int attempt = 1; attempt <= retryCount; attempt++) {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/games?category=$category'),
        );
        print('Full URL: ${response.request?.url}');
        print('Response Body: ${response.body}');
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
    throw Exception('Failed to load games by category after retries');
  }
}
