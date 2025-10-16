import 'dart:convert';

import 'package:http/http.dart' as http;

class SpotifyApi {
  static const _baseUrl = 'https://api.spotify.com/v1';

  static Future<Map<String, dynamic>> getArtist(String id) async {
    final token = await _getAuthToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/artists/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar el artista');
    }
  }

  static Future<String> _getAuthToken() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $base64EncodedCredentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['access_token'];
    } else {
      throw Exception('Error al obtener el auth token');
    }
  }

  static String get base64EncodedCredentials {
    final clientId = '43d92cf68e4440799cd2c78fcca06dec';
    final clientSecret = '1c9507c453e5462695924e7b2fe44fee';
    final credentials = '$clientId:$clientSecret';
    final bytes = utf8.encode(credentials);
    return base64.encode(bytes);
  }
}
