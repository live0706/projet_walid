import 'package:flutter/material.dart';
import '../widgets_web/header_widgets.dart';
import '../widgets_web/footer_widgets.dart';
import '../services_web/message_web_service.dart'; // À créer si non existant

class ContactWebScreen extends StatefulWidget {
  const ContactWebScreen({super.key});

  @override
  State<ContactWebScreen> createState() => _ContactWebScreenState();
}

class _ContactWebScreenState extends State<ContactWebScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  bool _messageEnvoye = false;

  Future<void> _envoyerMessage() async {
    if (_formKey.currentState!.validate()) {
      final success = await MessageService.envoyerMessage(
        utilisateurId: 1, // Remplace par l’ID réel de l’utilisateur
        contenu: _messageController.text.trim(),
      );

      if (success) {
        setState(() {
          _messageEnvoye = true;
          _messageController.clear();
        });
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Échec de l'envoi du message")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/restaurant.jpg', fit: BoxFit.cover)),
          // ignore: deprecated_member_use
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.5))),
          Column(
            children: [
              const HeaderWidget(currentRoute: 'contact'),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Contactez-nous",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Pour toute question ou suggestion, n'hésitez pas à nous contacter.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            const SizedBox(height: 30),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _messageController,
                                    maxLines: 5,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white24,
                                      hintText: "Votre message",
                                      hintStyle: const TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    validator: (value) =>
                                        value!.isEmpty ? "Veuillez entrer un message" : null,
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: _envoyerMessage,
                                    icon: const Icon(Icons.send),
                                    label: const Text("Envoyer le message"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto',
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_messageEnvoye)
                              const Text(
                                "Votre message a bien été envoyé au service Solideat.",
                                style: TextStyle(
                                  color: Colors.lightGreenAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: FooterWidget(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
