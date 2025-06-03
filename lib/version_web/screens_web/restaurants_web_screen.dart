import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets_web/header_widgets.dart';
import '../screens_web/reservations_web_screen.dart';
import '../widgets_web/footer_widgets.dart';
import '../screens_web/chat_web_screen.dart';

class RestaurantsWebScreen extends StatefulWidget {
  const RestaurantsWebScreen({super.key});

  @override
  State<RestaurantsWebScreen> createState() => _RestaurantsWebScreenState();
}

class _RestaurantsWebScreenState extends State<RestaurantsWebScreen> {
  List<dynamic> restaurants = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/restaurants'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          restaurants = data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Erreur lors du chargement des restaurants';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Erreur réseau : $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('assets/restaurant.jpg', fit: BoxFit.cover)),
          Positioned.fill(
              // ignore: deprecated_member_use
              child: Container(color: Colors.black.withOpacity(0.5))),
          Column(
            children: [
              const HeaderWidget(currentRoute: 'restaurants'),
              const SizedBox(height: 20),
              const Text(
                "Découvrez nos restaurants partenaires",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                        ? Center(
                            child: Text(
                              error!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 18),
                            ),
                          )
                        : CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isMobile ? 1 : 3,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: isMobile ? 3 / 2 : 1,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final restaurant = restaurants[index];
                                      final nom =
                                          restaurant['nom_restaurant'] ??
                                              'Nom inconnu';
                                      final adresse =
                                          restaurant['adresse'] ?? '';
                                      final ville = restaurant['ville'] ?? '';

                                      return Container(
                                        decoration: BoxDecoration(
                                          // ignore: deprecated_member_use
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: Image.asset(
                                                'assets/restaurant.jpg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              nom,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              '$adresse, $ville',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.chat_bubble_outline,
                                                    color: Colors.blueAccent,
                                                    size: 28,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            ChatWebScreen(
                                                          nomRestaurant: nom,
                                                          adresse: adresse,
                                                          restaurantId: index + 1,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(width: 12),
                                                ElevatedButton(
                                                  child:
                                                      const Text('Réserver'),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            ReservationsWebScreen(
                                                          nomRestaurant: nom,
                                                          adresse: adresse,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    childCount: restaurants.length,
                                  ),
                                ),
                              ),
                              const SliverToBoxAdapter(child: FooterWidget()),
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
