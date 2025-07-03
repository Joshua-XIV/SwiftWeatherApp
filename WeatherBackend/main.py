from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic_settings import BaseSettings
import os

class Settings(BaseSettings):
    WEATHER_API_KEY: str

    class Config:
        env_file = ".env"

settings = Settings()

app = FastAPI()

# Allow CORS
origins = [
    "http://localhost",
    "http://localhost:3000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/weather-api-key")
async def get_weather_api_key():
    if not settings.WEATHER_API_KEY:
        return {"error": "API key not set"}
    return {"api_key": settings.WEATHER_API_KEY}
