// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projet_app_walid/version_web/screens_web/connexion_web_screen.dart';
import 'package:projet_app_walid/version_web/services_web/profil_web_service.dart';
import 'package:projet_app_walid/version_web/widgets_web/header_widgets.dart';
import 'package:projet_app_walid/version_web/widgets_web/footer_widgets.dart';

class ProfilMobileScreen extends StatefulWidget {
  const ProfilMobileScreen({super.key});

  @override
  State<ProfilMobileScreen> createState() => _ProfilMobileScreenState();
}

class _ProfilMobileScreenState extends State<ProfilMobileScreen> {
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
    } catch (_) {
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/restaurant.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(color: Colors.black.withOpacity(0.6)),

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
                              : Container(
                                  width: isWideScreen ? 600 : double.infinity,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                          child: Text(
                                            "Bienvenue dans votre profil",
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),

                                        Text(
                                          "👤 Nom d'utilisateur : ${_profileData!['nom_utilisateur']}",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          "📧 Email : ${_profileData!['email']}",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(height: 24),

                                        // Réservations (bouton container)
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              _showReservations = !_showReservations;
                                              if (_showReservations) _showPrivacyPolicy = false;
                                            });
                                            if (_showReservations) {
                                              await _loadReservations();
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            margin: const EdgeInsets.only(bottom: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("📅 Mes réservations", style: TextStyle(fontSize: 16)),
                                                Icon(_showReservations ? Icons.expand_less : Icons.expand_more),
                                              ],
                                            ),
                                          ),
                                        ),

                                        if (_showReservations)
                                          Container(
                                            margin: const EdgeInsets.only(bottom: 24),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: _isLoadingReservations
                                                ? const Center(child: CircularProgressIndicator())
                                                : _reservations.isEmpty
                                                    ? const Text('Aucune réservation trouvée.', style: TextStyle(fontSize: 16))
                                                    : Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: _reservations.map((r) {
                                                          return Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                            child: Text(
                                                              '• Réservation #${r['reservation_id']} | ${r['date_reservation']}\nRestaurant: ${r['restaurant_id']} | Menu: ${r['menu']} | ${r['prix_total']}€',
                                                              style: const TextStyle(fontSize: 15),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                          ),

                                        // Politique de confidentialité (bouton container)
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _showPrivacyPolicy = !_showPrivacyPolicy;
                                              if (_showPrivacyPolicy) _showReservations = false;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            margin: const EdgeInsets.only(bottom: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text("🔒 Politique de confidentialité", style: TextStyle(fontSize: 16)),
                                                Icon(_showPrivacyPolicy ? Icons.expand_less : Icons.expand_more),
                                              ],
                                            ),
                                          ),
                                        ),

                                        if (_showPrivacyPolicy)
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              '''🔐 Politique de confidentialité :

Nous collectons uniquement les données nécessaires à la gestion de vos réservations : nom, email, identifiants de connexion et historique de réservation.

📁 Stockage sécurisé :
Vos données sont stockées de manière sécurisée et ne sont partagées avec aucun tiers sans votre consentement explicite.

🔄 Droits :
Vous pouvez à tout moment demander la suppression, modification ou consultation de vos données personnelles conformément au RGPD.

📬 Contact :
Pour toute question sur notre politique de confidentialité, contactez-nous via le formulaire du site.''',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),

                                        const SizedBox(height: 24),
                                        Center(
                                          child: ElevatedButton.icon(
                                            icon: const Icon(Icons.logout),
                                            label: const Text('Se déconnecter'),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red.shade700,
                                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                            ),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => const ConnexionWebScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                    ),
                  ),

                  const FooterWidget(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
