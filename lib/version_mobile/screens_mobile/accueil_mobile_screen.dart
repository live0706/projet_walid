import 'package:flutter/material.dart';
import 'package:projet_app_walid/version_mobile/screens_mobile/restaurants_mobile_screen.dart';
import '../widgets_mobile/header_widgets.dart';
import '../widgets_mobile/footer_widgets.dart';

class AccueilMobileScreen extends StatelessWidget {
  const AccueilMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/restaurant.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            // ignore: deprecated_member_use
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          Column(
            children: [
             const HeaderWidget(currentRoute: 'accueil'),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "  Choisissez. Commandez. Réservez. Nourrissez une autre vie. \n Chaque repas réservé est un geste pour les plus démunis.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RestaurantsMobileScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 6,
                        ),
                        child: const Text('Voir les restaurants'),
                      ),
                    ],
                  ),
                ),
              ),
              const FooterWidget(), // 👉 Footer ajouté ici
            ],
          ),
        ],
      ),
    );
  }
}
