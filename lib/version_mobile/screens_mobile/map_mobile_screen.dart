import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:projet_app_walid/version_mobile/screens_mobile/reservations_mobile_screen.dart';
class Restaurant {
  final String nom;
  final String adresse;
  final double lat;
  final double lon;

  Restaurant({
    required this.nom,
    required this.adresse,
    required this.lat,
    required this.lon,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final tt = json['tt'];
    return Restaurant(
      nom: json['nom_restaurant'],
      adresse: json['adresse'],
      lat: tt['lat'],
      lon: tt['lon'],
    );
  }
}

class MapMobileScreen extends StatefulWidget {
  const MapMobileScreen({super.key});

  @override
  State<MapMobileScreen> createState() => _MapMobileScreenState();
}

class _MapMobileScreenState extends State<MapMobileScreen> {
  List<Marker> markers = [];
  bool isLoading = true;

  final String url = 'http://192.168.234.5:8000/restaurants'; // change cette URL

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      final List<Restaurant> restaurants = data
          .where((json) => json['tt'] != null)
          .map((json) => Restaurant.fromJson(json))
          .toList();

      setState(() {
        markers = restaurants.map((r) {
          return Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(r.lat, r.lon),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReservationsWebScreen(
                      nomRestaurant: r.nom,
                      adresse: r.adresse,
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 30,
              ),
            ),
          );
        }).toList();
        isLoading = false;
      });
    }
  // ignore: empty_catches
  } catch (e) {
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(48.8566, 2.3522),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: markers),
              ],
            ),
    );
  }
}
