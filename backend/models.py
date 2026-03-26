from sqlalchemy import create_engine, Column, Integer, String, Text, Boolean
from sqlalchemy.orm import declarative_base, sessionmaker
from config import settings

engine = create_engine(
    settings.database_url, connect_args={"check_same_thread": False} if "sqlite" in settings.database_url else {}
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

class DBUser(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    password_hash = Column(String)
class DBQuestion(Base):
    __tablename__ = "questions"
    id = Column(String, primary_key=True, index=True)
    text = Column(String)
    category = Column(String)
    emoji = Column(String)

class DBCareer(Base):
    __tablename__ = "careers"
    code = Column(String, primary_key=True, index=True)
    title = Column(String)
    emoji = Column(String)
    description = Column(Text)
    stream = Column(String)
    salary = Column(String)
    growth = Column(String)
    education = Column(String)
    class_11_subjects = Column(String) # JSON string or comma-separated
    riasec_codes = Column(String)      # JSON string or comma-separated
    skills = Column(String)            # JSON string or comma-separated
    top_colleges = Column(String)      # JSON string or comma-separated
    bright_outlook = Column(Boolean, default=False)
