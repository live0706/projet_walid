import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilService {

  static final ProfilService _instance = ProfilService._internal();

  factory ProfilService() {
    return _instance;
  }

  ProfilService._internal();

  Future<Map<String, dynamic>?> getInstance() async {
    return await fetchProfile();
  }

 Future<Map<String, dynamic>?> fetchProfile() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  if (userId == null) return null;

  final response = await http.get(Uri.parse('http://127.0.0.1:8000/profile?user_id=$userId'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return null;
  }
}

  Future<List<dynamic>> fetchReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return [];
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/reservations/utilisateur/$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

}
