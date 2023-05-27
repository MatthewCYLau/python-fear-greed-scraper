from src.scraper.scraper import scrape
import logging

logging.basicConfig(level=logging.INFO)

def start_scraper():
    scrape()