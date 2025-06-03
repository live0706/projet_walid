import 'dart:convert';
import 'package:http/http.dart' as http;

class ConnexionService {
  final String baseUrl = 'http://192.168.234.5:8000'; // Remplacez par l'URL de votre API

  Future<int?> login(String email, String mdp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/connexion'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'mdp': mdp}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['id'] != null) {
        return data['id'];  // retourne l'id utilisateur
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
