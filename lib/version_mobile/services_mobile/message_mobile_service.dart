import 'dart:convert';
import 'package:http/http.dart' as http;

class MessageService {
  static Future<bool> envoyerMessage({
    required int utilisateurId,
    required String contenu,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.234.5:8000/messages'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'utilisateur_id': utilisateurId,
          'contenu': contenu,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
