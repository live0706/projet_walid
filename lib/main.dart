import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projet_app_walid/version_web/screens_web/connexion_web_screen.dart';
import 'package:projet_app_walid/version_mobile/screens_mobile/connexion_mobile_screen.dart';

void main() {
  runApp(const MaterialApp(
    home: kIsWeb ? ConnexionWebScreen() : ConnexionMobileScreen(),
  ));
}