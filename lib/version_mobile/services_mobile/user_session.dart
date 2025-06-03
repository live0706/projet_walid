import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const _userIdKey = 'userId';

  // Enregistrer l'ID utilisateur (après connexion)
  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  // Récupérer l'ID utilisateur (quand on en a besoin)
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // Supprimer l'ID utilisateur (à la déconnexion)
  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }
}
