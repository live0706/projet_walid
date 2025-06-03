import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projet_app_walid/version_mobile/widgets_mobile/header_widgets.dart';
import 'package:projet_app_walid/version_mobile/widgets_mobile/footer_widgets.dart';
import 'package:projet_app_walid/version_web/screens_web/commande_web_screen.dart';

class ReservationsWebScreen extends StatefulWidget {
  final String nomRestaurant;
  final String adresse;

  const ReservationsWebScreen({
    super.key,
    required this.nomRestaurant,
    required this.adresse,
  });

  @override
  State<ReservationsWebScreen> createState() => _ReservationsWebScreenState();
}

class _ReservationsWebScreenState extends State<ReservationsWebScreen> {
  List<dynamic> menuItems = [];
  List<dynamic> selectedItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    final response = await http.get(Uri.parse('http://192.168.234.5:8000/menu'));

    if (response.statusCode == 200) {
      setState(() {
        menuItems = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleSelection(item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/restaurant.jpg', fit: BoxFit.cover)),
          // ignore: deprecated_member_use
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.5))),
          SingleChildScrollView(
            child: Column(
              children: [
            const HeaderWidget(currentRoute: 'profil'),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      const Text(
                        'Vos réservations',
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Restaurant : ${widget.nomRestaurant}',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Adresse : ${widget.adresse}',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                SizedBox(
                  height: 350,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: menuItems.length,
                            itemBuilder: (context, index) {
                              final item = menuItems[index];
                              final isSelected = selectedItems.contains(item);

                              return Container(
                                width: 300,
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      // ignore: deprecated_member_use
                                      ? Colors.orange.shade100.withOpacity(0.9)
                                      // ignore: deprecated_member_use
                                      : Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(150),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(150)),
                                      child: SizedBox(
                                        height: 150,
                                        child: Image.asset(
                                          'assets/plat.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['nom'],
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          Text('Prix : ${item['prix']} €'),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Checkbox(
                                                value: isSelected,
                                                onChanged: (_) => toggleSelection(item),
                                              ),
                                              const Text('Sélectionner'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
                ElevatedButton(
                  onPressed: selectedItems.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommandeWebScreen(selectedPlats: selectedItems),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text('Commander les plats sélectionnés'),
                ),
                const SizedBox(height: 30),
                const FooterWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
