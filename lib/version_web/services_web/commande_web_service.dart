import 'dart:convert';
import 'package:http/http.dart' as http;

class PlatCommande {
  final String nom;
  final double prix;

  PlatCommande({required this.nom, required this.prix});

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'prix': prix,
      };
}

class ReservationService {
  static Future<bool> envoyerReservation({
    required int utilisateurId,
    required int restaurantId,
    required List<PlatCommande> plats,
  }) async {
    final url = Uri.parse('http://127.0.0.1:8000/reservation');

    // Construction du menu (ex: "Pizza, Salade")
    final menu = plats.map((p) => p.nom).join(', ');

    // Calcul du prix total
    final prixTotal = plats.fold(0.0, (sum, item) => sum + item.prix);

    final body = json.encode({
      'utilisateur_id': utilisateurId,
      'restaurant_id': restaurantId,
      'plats': plats.map((p) => p.toJson()).toList(),
      'menu': menu,
      'prix_total': prixTotal,
    });

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
