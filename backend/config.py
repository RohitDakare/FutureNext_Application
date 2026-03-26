from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import List

class Settings(BaseSettings):
    app_name: str = "Future Next API"
    environment: str = "dev"
    database_url: str = "sqlite:///./futurenext.db"
    cors_origins: List[str] = [
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "http://192.168.126.1:3000",
        "http://195.35.23.26",
    ] # Default allowed
    secret_key: str = "09d25e094faa6ca2556c818166b7a9563b93f7099f6f0f4caa6cf63b88e8d3e7"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    gemini_api_key: str = "AIzaSyAS8hAtGlUVihwwCA-CTkJuspns9025G7A"
    
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8"
    )

settings = Settings()
