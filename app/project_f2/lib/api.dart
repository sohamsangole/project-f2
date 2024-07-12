import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService();

  Future<Map<String, dynamic>> getCurrentSong(
      String baseUrl, String sessionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/current-song?key=$sessionId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load current song');
    }
  }

  Future<List<Map<String, dynamic>>> getTop5SongsLong(
      String baseUrl, String sessionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/top-tracks-long?key=$sessionId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<Map<String, dynamic>> topSongs = [];

      for (var song in responseData) {
        topSongs.add({
          'name': song['name'] ?? '',
          'artists': song['artists'] ?? '',
          'album': song['album'] ?? '',
          'album_cover': song['album_cover'] ?? '',
        });
      }

      return topSongs;
    } else {
      throw Exception('Failed to load top songs');
    }
  }

  Future<List<Map<String, dynamic>>> getTop5SongsMedium(
      String baseUrl, String sessionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/top-tracks-medium?key=$sessionId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<Map<String, dynamic>> topSongs = [];

      for (var song in responseData) {
        topSongs.add({
          'name': song['name'] ?? '',
          'artists': song['artists'] ?? '',
          'album': song['album'] ?? '',
          'album_cover': song['album_cover'] ?? '',
        });
      }

      return topSongs;
    } else {
      throw Exception('Failed to load top songs');
    }
  }

  Future<List<Map<String, dynamic>>> getTop5SongsShort(
      String baseUrl, String sessionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/top-tracks-short?key=$sessionId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      List<Map<String, dynamic>> topSongs = [];

      for (var song in responseData) {
        topSongs.add({
          'name': song['name'] ?? '',
          'artists': song['artists'] ?? '',
          'album': song['album'] ?? '',
          'album_cover': song['album_cover'] ?? '',
        });
      }

      return topSongs;
    } else {
      throw Exception('Failed to load top songs');
    }
  }
}
