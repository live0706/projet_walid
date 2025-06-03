// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projet_app_walid/version_web/services_web/inscription_web_service.dart';
import 'package:projet_app_walid/version_web/screens_web/connexion_web_screen.dart'; // ← Assure-toi que ce chemin est correct
import 'package:projet_app_walid/version_web/screens_web/accueil_web_screen.dart';
class InscriptionWebScreen extends StatefulWidget {
  const InscriptionWebScreen({super.key});

  @override
  State<InscriptionWebScreen> createState() => _InscriptionWebScreenState();
}

class _InscriptionWebScreenState extends State<InscriptionWebScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _mdpController = TextEditingController();
  final _confirmController = TextEditingController();

  final InscriptionService _service = InscriptionService();
  String? _message;

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _mdpController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

 Future<void> _inscrire() async {
  if (_formKey.currentState!.validate()) {
    final nom = _nomController.text.trim();
    final email = _emailController.text.trim();
    final mdp = _mdpController.text;

    try {
      final result = await _service.inscription(nom, email, mdp);
      if (result) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AccueilWebScreen()),
        );
      } else {
        setState(() {
          _message = "Nom d'utilisateur ou email déjà utilisé.";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Une erreur est survenue. Veuillez réessayer.";
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
          Image.asset('assets/restaurant.jpg', fit: BoxFit.cover),

          // ✅ Couche sombre
          // ignore: deprecated_member_use
          Container(color: Colors.black.withOpacity(0.5)),

          // ✅ Bouton de retour (flèche)
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ConnexionWebScreen()),
                );
              },
            ),
          ),

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
                        Image.asset('assets/logo.png', height: 80),
                        const SizedBox(height: 16),
                        const Text(
                          "Inscription",
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
                                controller: _nomController,
                                decoration: const InputDecoration(
                                  labelText: 'Nom utilisateur',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) => value == null || value.isEmpty
                                    ? 'Entrez un nom'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) => value == null || !value.contains('@')
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
                                validator: (value) => value == null || value.length < 6
                                    ? '6 caractères minimum'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _confirmController,
                                decoration: const InputDecoration(
                                  labelText: 'Confirmer le mot de passe',
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                                obscureText: true,
                                validator: (value) => value != _mdpController.text
                                    ? 'Les mots de passe ne correspondent pas'
                                    : null,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _inscrire,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("S'inscrire"),
                                ),
                              ),
                              if (_message != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  _message!,
                                  style: TextStyle(
                                    color: _message == "Inscription réussie !"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
