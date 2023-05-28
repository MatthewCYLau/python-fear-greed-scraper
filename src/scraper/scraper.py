import logging
import requests
from bs4 import BeautifulSoup

URL = "https://realpython.github.io/fake-jobs/"
class Scraper():
    def __init__ (self):
        pass;

    def start_scraper(self):
        logging.info('Start scraping...')
        page = requests.get(URL)
        soup = BeautifulSoup(page.content, "html.parser")
        results = soup.find(id="ResultsContainer")
        print(results.prettify())