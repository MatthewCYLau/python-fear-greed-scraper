from src.scraper.scraper import Scraper
from dotenv import load_dotenv
import logging

logging.basicConfig(level=logging.INFO)
load_dotenv()

def app():
    scraper = Scraper();
    scraper.start_scraper()