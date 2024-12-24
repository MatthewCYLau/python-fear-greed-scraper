import logging
import time
import datetime
from selenium import webdriver
from bson.objectid import ObjectId
from src.email.email import send_email
from src.db.setup import db
from src.record.models import Record
from src.event.models import Event
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
        user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.50 Safari/537.36"
        chrome_options.add_argument(f"user-agent={user_agent}")
        self.driver = webdriver.Chrome(options=chrome_options)
        self.driver.implicitly_wait(10)

    def start_scraper(self):
        logging.info("Start scraping...")
        start_time = time.perf_counter()
        class_name = "market-fng-gauge__dial-number-value"
        FEAR_GREED_URL = "https://edition.cnn.com/markets/fear-and-greed"
        try:
            self.driver.get(FEAR_GREED_URL)
            element_present = EC.visibility_of_any_elements_located(
                (By.CLASS_NAME, class_name)
            )
            WebDriverWait(self.driver, 10).until(element_present)
            time.sleep(5)
            el = self.driver.find_element(By.CLASS_NAME, class_name)
            index = el.text
            logging.info("Fear and greed index is: %s", index)
            record = Record(index=index)
            if self.is_sunday_or_monday():
                logging.info("Skip saving record for Sunday or Monday")
            else:
                if not Record.is_record_already_created_for_today():
                    logging.info("Saving record for index: %s", index)
                    record.save_to_database()
            triggered_alerts = self.get_alerts_equal_or_greater_than_current_index(
                int(index)
            )
            [self.create_event(i) for i in triggered_alerts]
            self.generate_emails(triggered_alerts, index)
        except NoSuchElementException as ex:
            self.fail(ex.msg)
        finally:
            end_time = time.perf_counter()
            formatted_time_taken = "{:.2f}".format(round(end_time - start_time, 2))
            logging.info(f"Time taken: {formatted_time_taken}")

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

    @staticmethod
    def create_event(alert):
        event = Event(alert["index"], alert_id=alert["_id"])
        event.save_to_database()

    @staticmethod
    def is_sunday_or_monday():
        return datetime.datetime.today().weekday() in [0, 6]

    @staticmethod
    def generate_emails(alerts, index):
        emails_sent_count = 0
        for i in alerts:
            if not isinstance(i["created_by"], dict):
                logging.warning("Alert does not contain user email")
                continue
            to_email_address = i["created_by"]["email"]
            note = i["note"]
            increase_amount = i["created_by"]["regularContributionAmount"] * (
                1 + ((int(index) - i["index"]) / 100)
            )
            increased_contribution = f"{increase_amount:.2f}"
            message = f"Fear and greed index is: {index}\n{note}\nIncrease contribution by {increased_contribution}"
            send_email(to_email_address, message)
            emails_sent_count += 1
        logging.info("Email notification sent to %s emails", emails_sent_count)
