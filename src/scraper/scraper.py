import logging
from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.by import By

class Scraper():
    def __init__ (self):
        chrome_options = webdriver.ChromeOptions()
        chrome_options.add_argument('--no-sandbox')
        chrome_options.add_argument('--headless')
        chrome_options.add_argument('--disable-gpu')
        chrome_options.add_argument('--disable-dev-shm-usage')
        chrome_options.add_argument("--window-size=1920,1080")
        self.driver = webdriver.Chrome(options=chrome_options)
        self.driver.implicitly_wait(10);        
    
    def start_scraper(self):
        logging.info('Start scraping...')
        try:
            self.driver.get('https://www.oursky.com/')
            el = self.driver.find_element(By.ID, 'heroTag')
            print(el.text)
        except NoSuchElementException as ex:
            self.fail(ex.msg)