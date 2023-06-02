from dotenv import load_dotenv
from src.scraper.scraper import Scraper
from .db.setup import db_connect
import logging

logging.basicConfig(level=logging.INFO)
load_dotenv()

db_connect()

def app():
    scraper = Scraper();
    scraper.start_scraper()