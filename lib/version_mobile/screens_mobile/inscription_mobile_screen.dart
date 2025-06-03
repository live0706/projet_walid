// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projet_app_walid/version_mobile/services_mobile/inscription_mobile_service.dart';
import 'package:projet_app_walid/version_mobile/screens_mobile/accueil_mobile_screen.dart';
import 'package:projet_app_walid/version_mobile/screens_mobile/connexion_mobile_screen.dart';

class InscriptionMobileScreen extends StatefulWidget {
  const InscriptionMobileScreen({super.key});

  @override
  State<InscriptionMobileScreen> createState() => _InscriptionMobileScreenState();
}

class _InscriptionMobileScreenState extends State<InscriptionMobileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _mdpController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
  String? _message;

  final InscriptionService _service = InscriptionService();

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
            MaterialPageRoute(builder: (context) => const AccueilMobileScreen()),
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
          Image.asset('assets/restaurant.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.5)),

          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ConnexionMobileScreen()),
                );
              },
            ),
          ),

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
                  color: Colors.white.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/logo.png', height: 80),
                        const SizedBox(height: 16),
                        const Text(
                          "Inscription",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Entrez un nom d’utilisateur';
                                  }
                                  final nameRegExp = RegExp(r'^[a-zA-Z0-9_]{3,}$');
                                  if (!nameRegExp.hasMatch(value.trim())) {
                                    return 'Nom invalide (min 3 lettres/chiffres)';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Entrez un email';
                                  }
                                  final emailRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                                  if (!emailRegExp.hasMatch(value.trim())) {
                                    return 'Format d’email invalide';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _mdpController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(_isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Entrez un mot de passe';
                                  }
                                  final passwordRegExp =
                                      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
                                  if (!passwordRegExp.hasMatch(value)) {
                                    return 'Min 8 caractères, 1 maj, 1 min, 1 chiffre';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _confirmController,
                                obscureText: !_isConfirmVisible,
                                decoration: InputDecoration(
                                  labelText: 'Confirmer le mot de passe',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(_isConfirmVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmVisible = !_isConfirmVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Confirmez votre mot de passe';
                                  }
                                  if (value != _mdpController.text) {
                                    return 'Les mots de passe ne correspondent pas';
                                  }
                                  return null;
                                },
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
