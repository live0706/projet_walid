import 'package:flutter/material.dart';
import 'package:projet_app_walid/version_web/screens_web/connexion_web_screen.dart';
import 'package:projet_app_walid/version_web/services_web/profil_web_service.dart';
import 'package:projet_app_walid/version_web/widgets_web/header_widgets.dart';
import 'package:projet_app_walid/version_web/widgets_web/footer_widgets.dart';

class ProfilWebScreen extends StatefulWidget {
  const ProfilWebScreen({super.key});

  @override
  State<ProfilWebScreen> createState() => _ProfilWebScreenState();
}

class _ProfilWebScreenState extends State<ProfilWebScreen> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  String? _errorMessage;

  bool _showPrivacyPolicy = false;
  bool _showReservations = false;

  final ProfilService _service = ProfilService();

  List<dynamic> _reservations = [];
  bool _isLoadingReservations = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await _service.fetchProfile();
      setState(() {
        _profileData = data;
        _isLoading = false;
        if (data == null) _errorMessage = "Profil introuvable";
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur lors du chargement";
        _isLoading = false;
      });
    }
  }

  Future<void> _loadReservations() async {
    setState(() => _isLoadingReservations = true);
    final reservations = await _service.fetchReservations();
    setState(() {
      _reservations = reservations;
      _isLoadingReservations = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/restaurant.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Semi-transparent overlay
          // ignore: deprecated_member_use
          Container(color: Colors.black.withOpacity(0.6)),

          // Main content
          Column(
            children: [
              const HeaderWidget(currentRoute: 'profil'),

              Expanded(
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : _errorMessage != null
                          ? Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            )
                          : Card(
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.9),
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        const Text(
                          "Bienvenue dans votre profil",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
          
                                      Text(
                                        "Nom d'utilisateur : ${_profileData!['nom_utilisateur']}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Email : ${_profileData!['email']}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(height: 24),

                                      // Mes réservations toggle
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            _showReservations = !_showReservations;
                                            if (_showReservations) _showPrivacyPolicy = false;
                                          });
                                          if (_showReservations) {
                                            await _loadReservations();
                                          }
                                        },
                                        child: Text(
                                          _showReservations ? 'Masquer Mes réservations' : 'Voir Mes réservations',
                                          style: const TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      if (_showReservations)
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          margin: const EdgeInsets.only(bottom: 24),
                                          color: Colors.grey[200],
                                          child: _isLoadingReservations
                                              ? const Center(child: CircularProgressIndicator())
                                              : _reservations.isEmpty
                                                  ? const Text('Aucune réservation trouvée.', style: TextStyle(fontSize: 16))
                                                  : Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: _reservations.map((r) => Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                        child: Text(
                                                          'Réservation #${r['reservation_id']} - Restaurant: ${r['restaurant_id']} - Menu: ${r['menu']} - Prix: ${r['prix_total']}€ - Date: ${r['date_reservation']}',
                                                          style: const TextStyle(fontSize: 16),
                                                        ),
                                                      )).toList(),
                                                    ),
                                        ),

                                      // Politique de confidentialité toggle
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _showPrivacyPolicy = !_showPrivacyPolicy;
                                            if (_showPrivacyPolicy) _showReservations = false;
                                          });
                                        },
                                        child: Text(
                                          _showPrivacyPolicy ? 'Masquer Politique de confidentialité' : 'Voir Politique de confidentialité',
                                          style: const TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontSize: 16,
                                            color: Colors.black
                                          ),
                                        ),
                                      ),
                                      if (_showPrivacyPolicy)
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          margin: const EdgeInsets.only(bottom: 24),
                                          color: Colors.grey[200],
                                          child: const Text(
                                            'Voici la politique de confidentialité complète...',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),

                                      // Bouton Se déconnecter
                                        Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ConnexionWebScreen(), // 👉 PAGE À CRÉER/IMPORTER
          ),
        );
                                          },
                                          child: const Text('Se déconnecter', style: TextStyle(fontSize: 18)),
                                        ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                ),
              ),

              const FooterWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
