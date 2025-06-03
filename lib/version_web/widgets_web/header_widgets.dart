import 'package:flutter/material.dart';
import 'package:projet_app_walid/version_web/screens_web/accueil_web_screen.dart';
import 'package:projet_app_walid/version_web/screens_web/restaurants_web_screen.dart';
import 'package:projet_app_walid/version_web/screens_web/contact_web_screen.dart';
import 'package:projet_app_walid/version_web/screens_web/profil_web_screen.dart';


class HeaderWidget extends StatelessWidget {
  final String currentRoute; // <-- Page active (ex: 'accueil', 'restaurants', 'propos', 'profil')

  const HeaderWidget({super.key, required this.currentRoute});

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.95),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo + nom
          Row(
            children: [
              Image.asset('assets/logo.png', height: 40),
              const SizedBox(width: 12),
              const Text(
                'SolidEAT',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),

          // Menu desktop ou hamburger
          isMobile
              ? Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, size: 30),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => Align(
                          alignment: Alignment.centerRight,
                          child: FractionallySizedBox(
                            widthFactor: 0.7,
                            child: Material(
                              color: Colors.white,
                              child: SafeArea(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        'Menu',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ),
                                    const Divider(),
                                    _DrawerItem(
                                      'Accueil',
                                      () => _navigate(context, const AccueilWebScreen()),
                                      isActive: currentRoute == 'accueil',
                                    ),
                                    _DrawerItem(
                                      'Restaurants',
                                      () => _navigate(context, const RestaurantsWebScreen()),
                                      isActive: currentRoute == 'restaurants',
                                    ),
                                    _DrawerItem(
                                      'Contact',
                                      () => _navigate(context, const ContactWebScreen()),
                                      isActive: currentRoute == 'contact',
                                    ),
                                   
                                    _DrawerItem(
                                      'Profil',
                                      () => _navigate(context, const ProfilWebScreen()),
                                      isActive: currentRoute == 'profil',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Row(
                  children: [
                    _MenuItem(
                      label: 'Accueil',
                      onTap: () => _navigate(context, const AccueilWebScreen()),
                      isActive: currentRoute == 'accueil',
                    ),
                    const SizedBox(width: 20),
                    _MenuItem(
                      label: 'Restaurants',
                      onTap: () => _navigate(context, const RestaurantsWebScreen()),
                      isActive: currentRoute == 'restaurants',
                    ),
                    const SizedBox(width: 20),
                    _MenuItem(
                      label: 'Contact',
                      onTap: () => _navigate(context, const ContactWebScreen()),
                      isActive: currentRoute == 'contact',
                    ),
                    const SizedBox(width: 20),
                  
                    IconButton(
                      icon: Icon(
                        Icons.account_circle,
                        size: 30,
                        color: currentRoute == 'profil' ? Colors.red : Colors.black87,
                      ),
                      onPressed: () => _navigate(context, const ProfilWebScreen()),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

// Lien menu desktop
class _MenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _MenuItem({
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: isActive ? Colors.red : Colors.black87,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}

// Élément menu hamburger
class _DrawerItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _DrawerItem(this.label, this.onTap, {this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: isActive ? Colors.red : Colors.black),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
