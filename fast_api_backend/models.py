from sqlalchemy import Column, Integer, String, Float, ForeignKey, DateTime, Text
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime

class Utilisateur(Base):
    __tablename__ = "utilisateurs"

    id = Column(Integer, primary_key=True, index=True)
    nom_utilisateur = Column(String, unique=True, nullable=False)
    email = Column(String, unique=True, nullable=False)
    mdp = Column(String, nullable=False)

    reservations = relationship("Reservation", back_populates="utilisateur")
    avis = relationship("Avis", back_populates="utilisateur")
    messages = relationship("Message", back_populates="utilisateur")

class Restaurant(Base):
    __tablename__ = "restaurants"

    id = Column(Integer, primary_key=True, index=True)
    code = Column(String, nullable=True)  # Code postal
    nom_restaurant = Column(String, nullable=True)  # Peut être null dans JSON
    adresse = Column(String, nullable=True)
    ville = Column(String, nullable=True)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    type = Column(String, nullable=True)
    description = Column(Text, nullable=True)

    reservations = relationship("Reservation", back_populates="restaurant")
    avis = relationship("Avis", back_populates="restaurant")

class Reservation(Base):
    __tablename__ = "reservations"

    id = Column(Integer, primary_key=True, index=True)
    utilisateur_id = Column(Integer, ForeignKey("utilisateurs.id"), nullable=False)
    restaurant_id = Column(Integer, ForeignKey("restaurants.id"), nullable=False)
    date_reservation = Column(DateTime, default=datetime.utcnow)
    prix_total = Column(Float, nullable=True)
    menu = Column(String)  # <-- nouveau champ

    utilisateur = relationship("Utilisateur", back_populates="reservations")
    restaurant = relationship("Restaurant", back_populates="reservations")

class Avis(Base):
    __tablename__ = "avis"

    id = Column(Integer, primary_key=True, index=True)
    utilisateur_id = Column(Integer, ForeignKey("utilisateurs.id"), nullable=False)
    restaurant_id = Column(Integer, ForeignKey("restaurants.id"), nullable=False)
    note = Column(Integer, nullable=False)  # Exemple : note de 1 à 5
    commentaire = Column(Text, nullable=True)

    utilisateur = relationship("Utilisateur", back_populates="avis")
    restaurant = relationship("Restaurant", back_populates="avis")

class Message(Base):
    __tablename__ = "messages"

    id = Column(Integer, primary_key=True, index=True)
    utilisateur_id = Column(Integer, ForeignKey("utilisateurs.id"), nullable=False)
    contenu = Column(Text, nullable=False)
    date_envoi = Column(DateTime, default=datetime.utcnow)

    utilisateur = relationship("Utilisateur", back_populates="messages")

