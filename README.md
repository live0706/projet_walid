# SolidEat

SolidEat est une application web et mobile de gestion de restaurants solidaires, développée en Flutter (web/mobile) avec un backend FastAPI (Python) et une base de données SQLite.

## Fonctionnalités principales
- Inscription et connexion des utilisateurs (web & mobile)
- Liste des restaurants partenaires
- Réservation de plats/menu dans un restaurant
- Système de chat/avis par restaurant (discussion et notation)
- Gestion du profil utilisateur et de ses réservations
- Backend FastAPI avec endpoints RESTful

## Architecture du projet

```
projet_app_walid/
│
├── lib/                       # Code Flutter (web & mobile)
│   ├── main.dart
│   ├── version_web/
│   └── version_mobile/
│
├── fast_api_backend/          # Backend FastAPI (web)
│   ├── main.py
│   ├── models.py
│   ├── schemas.py
│   ├── database.py
│   ├── restaurants.json
│   └── menu.json
│
├── fastapi_backend_mobile/    # Backend FastAPI (mobile)
│   ├── main.py
│   ├── models_mobile.py
│   ├── schemas_mobile.py
│   ├── database_mobile.py
│   ├── restaurants.json
│   └── menu.json
│
├── assets/                    # Images et ressources
└── ...
```

## Lancer le backend FastAPI

### Pour le web (sur le PC)
```bash
cd fast_api_backend
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Pour le mobile (émulateur Android)
```bash
cd fastapi_backend_mobile
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

- Pour accéder au backend depuis un navigateur ou un mobile réel, remplace `0.0.0.0` par l'IP locale de ton PC (ex : `192.168.x.x`).
- Pour l'émulateur Android, utilise l'URL `http://10.0.2.2:8000` dans tes appels HTTP Flutter.

## Lancer l'application Flutter

### Web
```bash
flutter run -d chrome
```

### Mobile (émulateur ou appareil réel)
```bash
flutter run -d <device_id>
```

## Configuration des URLs dans Flutter
- Web : utilise l'IP locale de ton PC (ex : `http://192.168.x.x:8000`)
- Mobile émulateur : `http://10.0.2.2:8000`
- Mobile réel : IP locale de ton PC

## Dépendances principales
- **Backend** : FastAPI, SQLAlchemy, Pydantic, Uvicorn
- **Frontend** : Flutter, http, shared_preferences

## Sécurité
- Les mots de passe ne sont pas hashés (⚠️ à faire pour la production)
- CORS ouvert pour le développement

## Auteurs
- Projet réalisé par des étudiants engagés pour la solidarité alimentaire.

## Licence
Ce projet est open-source et libre d'utilisation à des fins pédagogiques.
