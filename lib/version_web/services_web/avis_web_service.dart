import 'dart:convert';
import 'package:http/http.dart' as http;

class AvisService {
  final String baseUrl = 'http://127.0.0.1:8000';

  Future<List<dynamic>> getAvisByRestaurant(int restaurantId) async {
    final response = await http.get(Uri.parse('$baseUrl/avis/restaurant/$restaurantId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  Future<bool> postAvis({
    required int utilisateurId,
    required int restaurantId,
    required int note,
    String? commentaire,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/avis'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'utilisateur_id': utilisateurId,
        'restaurant_id': restaurantId,
        'note': note,
        'commentaire': commentaire,
      }),
    );
    return response.statusCode == 201;
  }
}
