"""
db.py
-----
Initializes the SQLAlchemy database object without binding it to the Flask
application. This avoids circular imports and allows the application factory
pattern (create_app) to attach the database cleanly.

Imported by:
- app.py to initialize SQLAlchemy
- models.py to define ORM models
"""
# db.py

from flask_sqlalchemy import SQLAlchemy

# Create SQLAlchemy object without binding to app yet
db = SQLAlchemy()