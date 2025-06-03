import 'dart:convert';
import 'package:http/http.dart' as http;

class InscriptionService {
  final String baseUrl = 'http://127.0.0.1:8000';

  Future<bool> inscription(String nomUtilisateur, String email, String mdp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/inscription'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom_utilisateur': nomUtilisateur,
        'email': email,
        'mdp': mdp,
      }),
    );

    if (response.statusCode == 201) {
      // Succès
      return true;
    } else if (response.statusCode == 409) {
      // Email ou nom déjà utilisé (conflit)
      return false;
    } else {
      // Autres erreurs (log optionnel)
      throw Exception('Erreur serveur : ${response.statusCode}');
    }
  }
}
