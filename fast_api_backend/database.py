from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# URL de la base SQLite
DATABASE_URL = "sqlite:///./solideat.db"

# Création du moteur SQLAlchemy
engine = create_engine(
    DATABASE_URL, connect_args={"check_same_thread": False}
)

# Création de la session locale
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

# Base déclarative pour définir les modèles
Base = declarative_base()
