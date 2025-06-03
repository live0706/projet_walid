import 'package:flutter/material.dart';
import '../screens_mobile/map_mobile_screen.dart'; // ⬅️ Assure-toi du bon chemin
import '../screens_mobile/accueil_mobile_screen.dart';
import '../screens_mobile/restaurants_mobile_screen.dart';
import '../screens_mobile/contact_mobile_screen.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLinks(),
                    const SizedBox(height: 20),
                    _buildMiniMap(),
                    const SizedBox(height: 20),
                    _buildCopyright(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildLinks()),
                    const SizedBox(width: 40),
                    Expanded(flex: 4, child: _buildMiniMap()),
                    const SizedBox(width: 40),
                    Expanded(flex: 2, child: _buildCopyright()),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _footerTitle("Liens utiles"),
        const SizedBox(height: 10),
        _footerLink(
          "Accueil",
          onTap: (BuildContext context) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AccueilMobileScreen()),
            );
          },
        ),
        _footerLink(
          "Restaurants",
          onTap: (BuildContext context) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RestaurantsMobileScreen()),
            );
          },
        ),
        _footerLink(
          "Contact",
          onTap: (BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ContactMobileScreen()),
        );
          },
        ),

  

      ],
    );
  }

  Widget _buildMiniMap() {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const MapMobileScreen(), // ⬅️ Carte intégrée directement
      ),
    );
  }

  Widget _buildCopyright() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "© 2025 SolidEat",
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(height: 8),
        Text(
          "Fait avec ❤️ par des étudiants engagés.",
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget _footerTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

 Widget _footerLink(String label, {required void Function(BuildContext) onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Builder(
      builder: (context) => InkWell(
        onTap: () => onTap(context),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ),
  );
}
}