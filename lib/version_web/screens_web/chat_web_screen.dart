import 'package:flutter/material.dart';
import 'package:projet_app_walid/version_web/services_web/avis_web_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:projet_app_walid/version_web/widgets_web/header_widgets.dart';
import 'package:projet_app_walid/version_web/widgets_web/footer_widgets.dart';

class ChatWebScreen extends StatefulWidget {
  final String nomRestaurant;
  final String adresse;
  final int restaurantId;
  const ChatWebScreen({
    super.key,
    required this.nomRestaurant,
    required this.adresse,
    required this.restaurantId,
  });

  @override
  State<ChatWebScreen> createState() => _ChatWebScreenState();
}

class _ChatWebScreenState extends State<ChatWebScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  List<dynamic> _avis = [];
  bool _isLoading = false;
  int? _userId;
  final AvisService _avisService = AvisService();

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _fetchAvis();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id');
    });
  }

  Future<void> _fetchAvis() async {
    setState(() => _isLoading = true);
    final avis = await _avisService.getAvisByRestaurant(widget.restaurantId);
    setState(() {
      _avis = avis;
      _isLoading = false;
    });
  }

  Future<void> _sendAvis() async {
    if (_messageController.text.trim().isEmpty || _userId == null) return;
    int note = int.tryParse(_noteController.text) ?? 5;
    final success = await _avisService.postAvis(
      utilisateurId: _userId!,
      restaurantId: widget.restaurantId,
      note: note,
      commentaire: _messageController.text.trim(),
    );
    if (success) {
      _messageController.clear();
      _noteController.clear();
      _fetchAvis();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/restaurant.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const HeaderWidget(currentRoute: 'restaurant'),
              Container(
                width: double.infinity,
                // ignore: deprecated_member_use
                color: Colors.blueGrey[50]?.withOpacity(0.85),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nomRestaurant,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.adresse,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _avis.length,
                        itemBuilder: (context, index) {
                          final avis = _avis[index];
                          final isMe = avis['utilisateur_id'] == _userId;
                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: isMe ? Colors.blue[100]?.withOpacity(0.85) : Colors.grey[300]?.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    avis['nom_utilisateur'] ?? 'Utilisateur inconnu',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    avis['commentaire'] ?? '',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  if (avis['note'] != null)
                                    Text('Note : ${avis['note']}/5', style: const TextStyle(fontSize: 12, color: Colors.orange)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _noteController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Note',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Écrivez un message... (avis)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendAvis,
                    ),
                  ],
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
