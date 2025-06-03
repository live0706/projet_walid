from pydantic import BaseModel, EmailStr
from typing import Optional
from typing import List

# Utilisateur
class Plat(BaseModel):
    nom: str
    prix: float
class UtilisateurCreate(BaseModel):
    nom_utilisateur: str
    email: EmailStr
    mdp: str

class UtilisateurOut(BaseModel):
    id: int
    nom_utilisateur: str
    email: EmailStr
class UtilisateurResponse(BaseModel):
    nom_utilisateur: str
    email: str

class ConnexionSchema(BaseModel):
    email: str
    mdp: str
class ProfilResponse(BaseModel):
    nom_utilisateur: str
    email: EmailStr

    class Config:
        orm_mode = True
class ConnexionResponse(BaseModel):
    message: str
    id: int
    nom_utilisateur: str
    email: str


# Restaurant

class RestaurantCreate(BaseModel):
    code: Optional[str] = None
    nom_restaurant: Optional[str] = None
    adresse: Optional[str] = None
    ville: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    type: Optional[str] = None
    description: Optional[str] = None

class RestaurantOut(RestaurantCreate):
    id: int

    class Config:
        orm_mode = True

# Réservation
class PlatCommande(BaseModel):
    nom: str
    prix: float
class ReservationCreate(BaseModel):
    utilisateur_id: int
    restaurant_id: int
    menu: str  # <-- nouveau champ
    plats: List[Plat]
# Avis

class AvisCreate(BaseModel):
    utilisateur_id: int
    restaurant_id: int
    note: int
    commentaire: Optional[str] = None

# Message

class MessageCreate(BaseModel):
    utilisateur_id: int
    contenu: str
    
