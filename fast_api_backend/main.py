from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
import json
from datetime import datetime
from pathlib import Path
from database import SessionLocal
from models import Utilisateur, Restaurant, Reservation, Message 
import models
from schemas import UtilisateurCreate, UtilisateurResponse, ConnexionSchema, ProfilResponse, ReservationCreate, ConnexionResponse, MessageCreate, AvisCreate # tu dois créer UtilisateurResponse et ConnexionSchema
from models import Base
from database import engine
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="SolidEat API", version="1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

json_path = Path(__file__).parent / "restaurants.json"
with open(json_path, "r", encoding="utf-8") as f:
    restaurants_data = json.load(f)
    def inserer_restaurants_en_bdd(db: Session):
        for r in restaurants_data:
            existing = db.query(models.Restaurant).filter_by(adresse=r.get("adresse")).first()
            if not existing:
                nouveau_restaurant = models.Restaurant(
                    adresse=r.get("adresse"),
                    latitude=r.get("latitude"),
                    longitude=r.get("longitude"),
                    description=r.get("description")
                )
                db.add(nouveau_restaurant)
        db.commit()

@app.on_event("startup")
def on_startup():
    db = SessionLocal()
    try:
        inserer_restaurants_en_bdd(db)
    finally:
        db.close()

@app.get("/")
def accueil():
    return {"message": "Bienvenue sur l'application SolidEat !"}

@app.get("/restaurants")
def get_restaurants_json():
    return restaurants_data

@app.get("/utilisateurs")
def get_utilisateurs(db: Session = Depends(get_db)):
    return db.query(models.Utilisateur).all()

@app.post("/inscription", response_model=UtilisateurResponse, status_code=201)
def inscription(utilisateur: UtilisateurCreate, db: Session = Depends(get_db)):
    utilisateur_existant = db.query(models.Utilisateur).filter(
        (models.Utilisateur.email == utilisateur.email) |
        (models.Utilisateur.nom_utilisateur == utilisateur.nom_utilisateur)
    ).first()

    if utilisateur_existant:
        raise HTTPException(status_code=409, detail="Nom d'utilisateur ou email déjà utilisé")

    nouveau_utilisateur = models.Utilisateur(
        nom_utilisateur=utilisateur.nom_utilisateur,
        email=utilisateur.email,
        mdp=utilisateur.mdp  # ⚠️ à hasher dans la vraie vie
    )
    db.add(nouveau_utilisateur)
    db.commit()
    db.refresh(nouveau_utilisateur)
    return nouveau_utilisateur
@app.post("/connexion", response_model=ConnexionResponse)
def connexion(utilisateur: ConnexionSchema, db: Session = Depends(get_db)):
    user = db.query(models.Utilisateur).filter_by(email=utilisateur.email).first()
    if not user or user.mdp != utilisateur.mdp:
        raise HTTPException(status_code=401, detail="Email ou mot de passe incorrect")
    
    return {
        "message": "Connexion réussie",
        "id": user.id,
        "nom_utilisateur": user.nom_utilisateur,
        "email": user.email
    }

@app.get("/profile")
def get_profile(user_id: int, db: Session = Depends(get_db)):
    utilisateur = db.query(Utilisateur).filter(Utilisateur.id == user_id).first()
    if not utilisateur:
        raise HTTPException(status_code=404, detail="Utilisateur non trouvé")
    return {
        "nom_utilisateur": utilisateur.nom_utilisateur,
        "email": utilisateur.email,
    }

@app.get("/menu")
def get_menu():
        menu_path = Path(__file__).parent / "menu.json"
        if not menu_path.exists():
            raise HTTPException(status_code=404, detail="Fichier menu.json non trouvé")
        with open(menu_path, "r", encoding="utf-8") as f:
            menu_data = json.load(f)
        return menu_data

@app.post("/reservation")
def creer_reservation(reservation: ReservationCreate, db: Session = Depends(get_db)):
    prix_total = sum([plat.prix for plat in reservation.plats])

    nouvelle_reservation = Reservation(
        utilisateur_id=reservation.utilisateur_id,
        restaurant_id=reservation.restaurant_id,
        menu=reservation.menu,
        prix_total=prix_total,
        date_reservation=datetime.utcnow()
    )

    db.add(nouvelle_reservation)
    db.commit()
    db.refresh(nouvelle_reservation)
    return {"message": "Réservation créée avec succès"}

@app.get("/reservation/{reservation_id}")
def get_reservation(reservation_id: int, db: Session = Depends(get_db)):
    reservation = db.query(Reservation).filter_by(id=reservation_id).first()
    if not reservation:
        raise HTTPException(status_code=404, detail="Réservation introuvable")
    return {
        "reservation_id": reservation.id,
        "utilisateur_id": reservation.utilisateur_id,
        "restaurant_id": reservation.restaurant_id,
        "menu": reservation.menu,
        "prix_total": reservation.prix_total,
        "date_reservation": reservation.date_reservation
    }

@app.post("/messages", status_code=201)
def create_message(message: MessageCreate, db: Session = Depends(get_db)):
    db_message = Message(
        utilisateur_id=message.utilisateur_id,
        contenu=message.contenu,
        date_envoi=datetime.utcnow()
    )
    db.add(db_message)
    db.commit()
    db.refresh(db_message)
    return db_message
@app.get("/messages")
def get_messages(db: Session = Depends(get_db)):
        messages = db.query(Message).all()
        return messages

@app.get("/reservations/utilisateur/{user_id}")
def get_reservations_by_user(user_id: int, db: Session = Depends(get_db)):
    reservations = db.query(Reservation).filter(Reservation.utilisateur_id == user_id).all()
    return [
        {
            "reservation_id": r.id,
            "restaurant_id": r.restaurant_id,
            "menu": r.menu,
            "prix_total": r.prix_total,
            "date_reservation": r.date_reservation
        }
        for r in reservations
    ]

from schemas import AvisCreate

@app.post("/avis", status_code=201)
def create_avis(avis: AvisCreate, db: Session = Depends(get_db)):
    db_avis = models.Avis(
        utilisateur_id=avis.utilisateur_id,
        restaurant_id=avis.restaurant_id,
        note=avis.note,
        commentaire=avis.commentaire
    )
    db.add(db_avis)
    db.commit()
    db.refresh(db_avis)
    return db_avis

@app.get("/avis/restaurant/{restaurant_id}")
def get_avis_by_restaurant(restaurant_id: int, db: Session = Depends(get_db)):
    avis_list = db.query(models.Avis).filter(models.Avis.restaurant_id == restaurant_id).all()
    result = []
    for avis in avis_list:
        utilisateur = db.query(models.Utilisateur).filter(models.Utilisateur.id == avis.utilisateur_id).first()
        result.append({
            "id": avis.id,
            "utilisateur_id": avis.utilisateur_id,
            "nom_utilisateur": utilisateur.nom_utilisateur if utilisateur else None,
            "note": avis.note,
            "commentaire": avis.commentaire,
            "date": str(getattr(avis, 'date', ''))
        })
    return result