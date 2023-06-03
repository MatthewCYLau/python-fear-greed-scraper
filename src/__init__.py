from dotenv import load_dotenv
load_dotenv()

from src.scraper.scraper import Scraper
from .db.setup import db_connect
import logging
import os

logging.basicConfig(level=logging.INFO)

if os.environ.get("MONGO_DB_CONNECTION_STRING"):
    db_connect()

def app():
    scraper = Scraper();
    scraper.start_scraper()