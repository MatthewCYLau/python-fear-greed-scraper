from src.scraper.scraper import Scraper
import logging

logging.basicConfig(level=logging.INFO)

def app():
    scraper = Scraper();
    scraper.start_scraper()