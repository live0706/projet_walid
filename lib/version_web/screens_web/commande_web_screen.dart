import 'package:flutter/material.dart';
import 'package:projet_app_walid/version_web/screens_web/profil_web_screen.dart';
import 'package:projet_app_walid/version_web/widgets_web/header_widgets.dart';
import 'package:projet_app_walid/version_web/widgets_web/footer_widgets.dart';
import 'package:projet_app_walid/version_web/services_web/commande_web_service.dart';

class CommandeWebScreen extends StatefulWidget {
  final List<dynamic> selectedPlats;

  const CommandeWebScreen({super.key, required this.selectedPlats});

  @override
  State<CommandeWebScreen> createState() => _CommandeWebScreenState();
}

class _CommandeWebScreenState extends State<CommandeWebScreen> {
  bool _isSending = false;
  bool _commandeValidee = false;

  Future<void> _validerCommande() async {
    setState(() => _isSending = true);

    try {
      int utilisateurId = 1;
      int restaurantId = 2;

      List<PlatCommande> plats = widget.selectedPlats.map((plat) {
        return PlatCommande(
          nom: plat['nom'],
          prix: (plat['prix'] as num).toDouble(),
        );
      }).toList();

      bool success = await ReservationService.envoyerReservation(
        utilisateurId: utilisateurId,
        restaurantId: restaurantId,
        plats: plats,
      );

      if (success) {
        setState(() {
          _commandeValidee = true;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Commande envoyée avec succès !')),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Échec de l\'envoi de la commande.')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    widget.selectedPlats.fold(
      0.0,
      (sum, item) => sum + ((item['prix'] ?? 0) as num).toDouble(),
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/restaurant.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            // ignore: deprecated_member_use
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          SingleChildScrollView(
           child: Column(
  children: [
    const HeaderWidget(currentRoute: 'profil'),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: _commandeValidee
          ? Column(
              children: [
                const Text(
                  'Merci pour votre générosité !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                     Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfilWebScreen(), // 👉 PAGE À CRÉER/IMPORTER
          ),
        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text(
                    'Voir vos réservations',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Récapitulatif de votre commande',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.selectedPlats.length,
                  itemBuilder: (context, index) {
                    final plat = widget.selectedPlats[index];
                    return Card(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.9),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(plat['nom']),
                        trailing: Text('${plat['prix']} €'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Total : ${widget.selectedPlats.fold(0.0, (sum, item) => sum + ((item['prix'] ?? 0) as num).toDouble()).toStringAsFixed(2)} €',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _isSending ? null : _validerCommande,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: _isSending
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Valider la commande',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
    ),
    const FooterWidget(),
  ],
),
          ),
        ],
      ),
    );
  }
}
