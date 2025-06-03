import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_app_walid/version_mobile/services_mobile/connexion_mobile_service.dart';
import 'package:projet_app_walid/version_mobile/screens_mobile/accueil_mobile_screen.dart';
import 'package:projet_app_walid/version_mobile/screens_mobile/inscription_mobile_screen.dart'; // Assurez-vous que ce chemin est correct

class ConnexionMobileScreen extends StatefulWidget {
  const ConnexionMobileScreen({super.key});

  @override
  State<ConnexionMobileScreen> createState() => _ConnexionMobileScreenState();
}

class _ConnexionMobileScreenState extends State<ConnexionMobileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _mdpController = TextEditingController();

  final ConnexionService _service = ConnexionService();

  String? _message;

  @override
  void dispose() {
    _emailController.dispose();
    _mdpController.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
  if (_formKey.currentState!.validate()) {
    final email = _emailController.text.trim();
    final mdp = _mdpController.text;

    try {
      final userId = await _service.login(email, mdp);

      if (userId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', userId);

        // DEBUG: affichage ID utilisateur

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const AccueilMobileScreen()),
        );
      } else {
        setState(() {
          _message = "Email ou mot de passe incorrect.";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Une erreur est survenue.";
      });
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ Image de fond
          Image.asset(
            'assets/restaurant.jpg', // remplace par ton image
            fit: BoxFit.cover,
          ),

          // ✅ Couche semi-transparente pour lisibilité
          // ignore: deprecated_member_use
          Container(color: Colors.black.withOpacity(0.5)),

          // ✅ Formulaire centré
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 8,
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ Logo
                        Image.asset(
                          'assets/logo.png',
                          height: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Connexion',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) =>
                                    value == null || !value.contains('@')
                                        ? 'Entrez un email valide'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _mdpController,
                                decoration: const InputDecoration(
                                  labelText: 'Mot de passe',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                obscureText: true,
                                validator: (value) =>
                                    value == null || value.length < 6
                                        ? 'Mot de passe invalide'
                                        : null,
                              ),
                              const SizedBox(height: 24),
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: _seConnecter,
    // ignore: sort_child_properties_last
    child: const Text("Se connecter"),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
),
if (_message != null) ...[
  const SizedBox(height: 16),
  Text(
    _message!,
    style: TextStyle(
      color: _message == "Connexion réussie !"
          ? Colors.green
          : Colors.red,
    ),
  ),
],
const SizedBox(height: 16),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text("Vous n'avez pas de compte ? "),
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const InscriptionMobileScreen(), // 👉 PAGE À CRÉER/IMPORTER
          ),
        );
      },
      child: const Text(
        "S'inscrire",
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
  ],
),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
