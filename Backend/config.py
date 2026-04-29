"""
config.py
---------
Centralized configuration for database connection and SQLAlchemy settings.
This file isolates credentials and environment-specific values so the rest
of the application remains clean, modular, and environment‑agnostic.

Used by:
- app.py for Flask configuration
- db.py and models.py indirectly through SQLAlchemy

Database:
  User: cs348
  Host: localhost
  Name: cs348proj
  Charset: utf8mb4 (full Unicode support)
"""

DB_USER = "cs348"
DB_PASSWORD = "NormalUser#1"
DB_HOST = "localhost"
DB_NAME = "cs348proj"

# SQLAlchemy connection string with utf8mb4 support
SQLALCHEMY_DATABASE_URI = (
    f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}?charset=utf8mb4"
)

SQLALCHEMY_TRACK_MODIFICATIONS = False

print("After database uri setup\n")