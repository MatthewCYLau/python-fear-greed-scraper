import logging
import time
from selenium import webdriver
from bson.objectid import ObjectId
from src.email.email import send_email
from src.db.setup import db
from src.record.models import Record
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class Scraper:
    def __init__(self):
        chrome_options = webdriver.ChromeOptions()
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--headless")
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--window-size=1920,1080")
        self.driver = webdriver.Chrome(options=chrome_options)
        self.driver.implicitly_wait(10)

    def start_scraper(self):
        logging.info("Start scraping...")
        try:
            self.driver.get("https://edition.cnn.com/markets/fear-and-greed")
            element_present = EC.visibility_of_any_elements_located(
                (By.CLASS_NAME, "market-fng-gauge__dial-number-value")
            )
            WebDriverWait(self.driver, 5).until(element_present)
            time.sleep(5)
            el = self.driver.find_element(
                By.CLASS_NAME, "market-fng-gauge__dial-number-value"
            )
            index = el.text
            logging.info("Fear and greed index is: %s", index)
            record = Record(index=index)
            record.save_to_database()
            triggered_alerts = self.get_alerts_equal_or_greater_than_current_index(
                int(index)
            )
            emails = [i["created_by"]["email"] for i in triggered_alerts]
            [send_email(i, index) for i in emails]
            logging.info("Email notification sent to %s emails", len(emails))
        except NoSuchElementException as ex:
            self.fail(ex.msg)

    @staticmethod
    def should_send_email(index: int) -> bool:
        return index < 35

    @staticmethod
    def get_alerts_equal_or_greater_than_current_index(min_index: int):
        alerts = list(db["alerts"].find({"index": {"$gt": min_index - 1}}).limit(0))
        for alert in alerts:
            if alert["created_by"]:
                alert["created_by"] = db["users"].find_one(
                    {"_id": ObjectId(alert["created_by"])}, {"password": False}
                )
        return alerts
